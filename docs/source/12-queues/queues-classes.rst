Работа с очередью сообщений
===========================

Примеры использования можно посмотреть и попробовать в проекте `InfinniPlatform.Northwind <https://github.com/InfinniPlatform/InfinniPlatform.Northwind>`_


.. index:: ITaskProducer
.. index:: IBroadcastProducer

Отправитель сообщений
---------------------

Для отправки сообщений в :doc:`очередь задач <queues-types>` следует использовать интерфейс ``ITaskProducer``. 

.. code-block:: csharp
   :emphasize-lines: 3,15,18

    public class SomePublisher
    {
        public SomePublisher(ITaskProducer taskProducer)
        {
            _taskProducer = taskProducer;
        }

        private readonly ITaskProducer _taskProducer;

        public async Task<object> SendMessages(SomeMessage message)
        {
            // ...

            // Асинхронный вызов
            await _taskProducer.PublishAsync(message);

            // Синхронный вызов
            _taskProducer.Publish(message);

            // ...
        }
    }

Для отправки сообщений в :doc:`широковещательную очередь <queues-types>` следует использовать интерфейс ``IBroadcastProducer``.

.. code-block:: csharp
   :emphasize-lines: 3,15,18

    public class SomePublisher
    {
        public SomePublisher(IBroadcastProducer broadcastProducer)
        {
            _broadcastProducer = broadcastProducer;
        }

        private readonly IBroadcastProducer _broadcastProducer;

        public async Task<object> SendMessages(SomeMessage message)
        {
            // ...

            // Асинхронный вызов
            await _broadcastProducer.PublishAsync(message);

            // Синхронный вызов
            _broadcastProducer.Publish(message);

            // ...
        }
    }


Получатель сообщений
---------------------

.. index:: TaskConsumerBase<T>

Для реализации получателя сообщений из :doc:`очереди задач <queues-types>` следует создать наследник от базового класса ``TaskConsumerBase<T>``.

.. code-block:: csharp
   :emphasize-lines: 1,3

    public class SomeConsumer : TaskConsumerBase<SomeMessage>
    {
        protected override async Task Consume(Message<SomeMessage> message)
        {
            // Логика обработки сообщения
        }
    }

.. index:: BroadcastConsumerBase<T>

Для реализации получателя сообщений из :doc:`широковещательной очереди <queues-types>` следует создать наследник от базового класса ``BroadcastConsumerBase<T>``.

.. code-block:: csharp
   :emphasize-lines: 1,3

    public class SomeConsumer : BroadcastConsumerBase<SomeMessage>
    {
        protected override async Task Consume(Message<SomeMessage> message)
        {
            // Логика обработки сообщения
        }
    }

.. index:: IOnDemandConsumer<T>

Для получения сообщений из :doc:`очереди задач <queues-types>` по запросу следует использовать интерфейс ``IOnDemandConsumer``.

.. code-block:: csharp
   :emphasize-lines: 3,12

    public class SomeConsumer
    {
        public SomeConsumer(IOnDemandConsumer onDemandConsumer)
        {
            _onDemandConsumer = onDemandConsumer;
        }

        private readonly IOnDemandConsumer _onDemandConsumer;

        public async Task<SomeMessage> GetMessage()
        {
            var message = await _onDemandConsumer.Consume<SomeMessage>("OnDemandQueueName");

            return (message != null) ? (SomeMessage)message.GetBody() : null;
        }
    }


.. index:: IContainerBuilder.RegisterConsumers()

Регистрация получателей
-----------------------

Для :doc:`регистрации в IoC-контейнере </02-ioc/container-builder>` всех получателей, объявленных в сборке, можно использовать метод расширения ``RegisterConsumers()``.

.. code-block:: csharp

    builder.RegisterConsumers(assembly);

Для :doc:`регистрации в IoC-контейнере </02-ioc/container-builder>` определенных получателей следует явно регистрировать их типы, как в примере ниже.

1. ``ITaskConsumer`` - для получателя сообщений из очереди задач.

.. code-block:: csharp
   :emphasize-lines: 3,8

    // Регистрация получателя сообщений очереди задач
    builder.RegisterType<SomeTaskConsumer>()
           .As<ITaskConsumer>()
           .SingleInstance();

    // Регистрация получателя сообщений широковещательной очереди
    builder.RegisterType<SomeBroadcastConsumer>()
           .As<IBroadcastConsumer>()
           .SingleInstance();


.. index:: QueueNameAttribute

Определение имени очереди
-------------------------

Если при отправке и получении сообщений без указания имени очереди действуют определенные соглашения. По умолчанию именем очереди
является полное имя типа отправляемого сообщения.

.. code-block:: csharp

    namespace InfinniPlatform.Northwind.Queues
    {
        public class SomeMessage
        {
            /* Сообщения этого типа будут отправлены в очередь с именем
               "InfinniPlatform.Northwind.Queues.SomeMessage" */
        }
    }

Для явного указания имени очереди следует использовать атрибут ``QueueNameAttribute``, которым помечается класс получателя сообщений.

.. code-block:: csharp

    [QueueName("DynamicQueue")]
    public class SomeConsumer : BroadcastConsumerBase<SomeMessage>
    {
        protected override async Task Consume(Message<SomeMessage> message)
        {
            /* Этот получатель будет обрабатывать только сообщения
               отправленные в очередь с именем "DynamicQueue" */
        }
    }
