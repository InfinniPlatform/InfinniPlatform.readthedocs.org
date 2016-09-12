.. index:: IJobInfoSource

Источник заданий
================

В приложении InfinniPlatform могут быть определены несколько источников заданий - объектов, предоставляющих
:doc:`информацию о запланированных заданиях </17-scheduler/index>` планировщика. Источник заданий - это
класс, реализующий интерфейс ``InfinniPlatform.Scheduler.Contract.IJobInfoSource``. Источники заданий
опрашиваются :doc:`после запуска приложения </03-hosting/index>`, чтобы произвести инициализацию
планировщика заданий. При этом у каждого источника вызывается метод ``GetJobs()``.


.. index:: IContainerBuilder.RegisterJobInfoSources

Регистрация источника заданий
-----------------------------

Создание экземпляров источников заданий и управление ими осуществляется посредством :doc:`IoC-контейнера </02-ioc/index>`.
По этой причине все источники должны быть :doc:`зарегистрированы в IoC-контейнере </02-ioc/container-builder>`,
например, так, как показано в следующем примере.

.. code-block:: csharp
   :emphasize-lines: 6

    IContainerBuilder builder;

    ...

    builder.RegisterType<SomeJobInfoSource>()
           .As<IJobInfoSource>()
           .SingleInstance();

Чтобы не производить регистрацию каждого источника в отдельности, можно воспользоваться универсальным методом
расширения ``RegisterJobInfoSources()``, который производит регистрацию всех обработчиков указанной сборки.

.. code-block:: csharp
   :emphasize-lines: 5

    IContainerBuilder builder;

    ...

    builder.RegisterJobInfoSources(assembly);


.. _persistent-job-info-source:

Источник сохраненных заданий
----------------------------

При реализации функциональных требований приложения может возникнуть потребность в добавлении заданий во время работы приложения
и сохранении :doc:`информации об этих заданиях </17-scheduler/index>` в :doc:`постоянном хранилище </08-document-storage/index>`,
чтобы гарантировать их выполнение после перезапуска приложения. Например, в качестве таких заданий могут быть персональные
напоминания пользователя или какие-либо иные задания, появление которых нельзя предсказать заранее.

Планировщик задач InfinniPlatform имеет встроенный источник сохраненных заданий. Все задания, :ref:`добавленные <add-or-update-job>`
с помощью метода ``IJobScheduler.AddOrUpdateJob()``, сохраняются в постоянное хранилище и учитываются при запуске приложения.
Управление такими заданиями ничем не отличается от :doc:`управления </17-scheduler/scheduler-jobscheduler>` обычными заданиями,
описанными в коде приложения.


Пример источника заданий
------------------------

Для создания источника заданий достаточно создать класс, реализующий интерфейс ``InfinniPlatform.Scheduler.Contract.IJobInfoSource``
с единственным методом ``GetJobs()``. В конструктор источника можно передать любые зависимости, 
:doc:`зарегистрированные в IoC-контейнере </02-ioc/container-builder>`. Важно отметить, что метод
``GetJobs()`` является асинхронным, благодаря чему становится возможным использовать все преимущества
асинхронного программирования с использованием ключевых слов `async/await`_.

.. code-block:: csharp
   :emphasize-lines: 1,3

    public class SomeJobInfoSource : IJobInfoSource
    {
        public Task<IEnumerable<IJobInfo>> GetJobs(IJobInfoFactory factory)
        {
            var jobs = new[]
                       {
                           // Задание с именем "SomeJob" будет выполняться ежедневно
                           // в 10:35 с помощью обработчика SomeJobHandler
                           factory.CreateJobInfo<SomeJobHandler>("SomeJob",
                               b => b.CronExpression(e => e.AtHourAndMinuteDaily(10, 35)))
                       };

            return Task.FromResult<IEnumerable<IJobInfo>>(jobs);
        }
    }


.. _`async/await`: https://msdn.microsoft.com/en-us/library/mt674882.aspx
