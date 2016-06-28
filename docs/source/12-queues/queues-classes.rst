Основные абстракции для работы с очередью сообщений
===================================================

Примеры использования можно посмотреть и опробовать в проекте `InfinniPlatform.Northwind <https://github.com/InfinniPlatform/InfinniPlatform.Northwind>`_

Отправитель сообщений
---------------------

``ITaskProducer`` - интерфейс отправителя сообщений в очередь задач. Пример:

.. code-block:: csharp

    public class SomeClass
    {
        public MessageProducerHttpService(ITaskProducer taskProducer)
        {
            _taskProducer = taskProducer;
        }

        private readonly ITaskProducer _taskProducer;

        private async Task<object> SendMessages()
        {
            /* ... */

            /* Асинхронный вызов */
            var message = await _taskProducer.PublishAsync(new ExampleMessage());

            /* Синхронный вызов */
            var message = _taskProducer.Publish(new ExampleMessage());

            /* ... */
        }
    }

``IBroadcastProducer`` - интерфейс отправителя сообщений в широковещательную очередь. Пример:

.. code-block:: csharp

    public class SomeClass
    {
        public MessageProducerHttpService(IBroadcastProducer broadcastProducer)
        {
            _broadcastProducer = broadcastProducer;
        }

        private readonly IBroadcastProducer _broadcastProducer;

        private async Task<object> SendMessages()
        {
            /* ... */

            /* Асинхронный вызов */
            var message = await _broadcastProducer.PublishAsync(new ExampleMessage());

            /* Синхронный вызов */
            var message = _broadcastProducer.Publish(new ExampleMessage());

            /* ... */
        }
    }


Получатель сообщений
---------------------

1. ``TaskConsumerBase<T>`` - базовый класс получателя сообщений из очереди задач. Используется для реализации логики получения сообщений.

.. code-block:: csharp

    public class TaskConsumerOne : TaskConsumerBase<ExampleMessage>
    {
        protected override async Task Consume(Message<ExampleMessage> message)
        {
            /*  place some logic here */
        }
    }


2. ``BroadcastConsumerBase<T>`` - базовый класс получателя сообщений из очереди задач. Используется для реализации логики получения сообщений:

.. code-block:: csharp

    public class BroadcastConsumerOne : BroadcastConsumerBase<DynamicWrapper>
    {
        protected override async Task Consume(Message<DynamicWrapper> message)
        {
            /*  place some logic here */
        }
    }

3. ``IOnDemandConsumer`` - интерфейс потребителя сообщений из очереди задач "по запросу".

.. code-block:: csharp

    public class SomeClass
    {
        public SomeClass(IOnDemandConsumer onDemandConsumer)
        {
            _onDemandConsumer = onDemandConsumer;
        }

        private readonly IOnDemandConsumer _onDemandConsumer;

        private async Task<object> GetMessages(IHttpRequest httpRequest)
        {
            var message = await _onDemandConsumer.Consume<ExampleMessage>("OnDemandQueue");

            if (message == null)
            {
                return null;
            }

            var body = (ExampleMessage)message.GetBody();

            return $"{body}";
        }
    }


Регистрация потребителей
------------------------

Для регистрации всех получателяей, объявленных в сборке, можно использовать метод ``RegisterConsumers()``:

.. code-block:: csharp

    builder.RegisterConsumers(assembly);

Для регистрации отдельных получателей в IoC-контейнере существует два интерфейса:

1. ``ITaskConsumer`` - для получателя сообщений из очереди задач.

.. code-block:: csharp

    builder.RegisterType<TaskConsumerOne>()
           .As<ITaskConsumer>()
           .SingleInstance();

2. ``IBroadcastConsumer`` - для получателя сообщений из широковещательной очереди.

.. code-block:: csharp

    builder.RegisterType<TaskConsumerOne>()
           .As<IBroadcastConsumer>()
           .SingleInstance();


Имя очереди
-----------

По умолчанию именем очереди является полное имя типа отправляетого сообщения, например:

.. code-block:: csharp

    namespace InfinniPlatform.Northwind.Queues
    {
        public class ExampleMessage
        {
            /* Сообщения этого типа будут отправлены в очередь с именем "InfinniPlatform.Northwind.Queues.ExampleMessage" */
        }
    }


``QueueNameAttribute`` - атрибут определяющий имя очереди для потребителя или сообщения.

.. code-block:: csharp

    [QueueName("DynamicQueue")]
    public class BroadcastConsumerTwo : BroadcastConsumerBase<ExampleMessage>
    {
        protected override async Task Consume(Message<ExampleMessage> message)
        {
            /* Этот получатель будет обрабатывать только сообщения отправленные в очередь с именем "DynamicQueue" */
        }
    }