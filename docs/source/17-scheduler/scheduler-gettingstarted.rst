Начало работы
=============

Ниже приведена краткая инструкция для начала работы с планировщиком заданий InfinniPlatform.

Установка планировщика заданий
------------------------------

Планировщик заданий InfinniPlatform выполнен в виде отдельного NuGet-пакета ``InfinniPlatform.Scheduler``,
который необходимо установить, выполнив следующую команду в `Package Manager Console`_.

.. code-block:: bash

    PM> Install-Package InfinniPlatform.Scheduler -Pre

Пример простого обработчика заданий
-----------------------------------

Добавьте в проект файл ``SomeJobHandler.cs`` с одноименным классом :doc:`обработчика заданий </17-scheduler/scheduler-jobhandler>`.

.. code-block:: js
   :caption: SomeJobHandler.cs
   :emphasize-lines: 6,8

    using System;
    using System.Threading.Tasks;

    using InfinniPlatform.Scheduler.Contract;

    public class SomeJobHandler : IJobHandler
    {
        public async Task Handle(IJobInfo jobInfo, IJobHandlerContext context)
        {
            await Console.Out.WriteLineAsync($"Greetings from {nameof(SomeJobHandler)}!");
        }
    }

Добавьте в проект файл ``SomeJobInfoSource.cs`` с одноименным классом :doc:`источника заданий </17-scheduler/scheduler-jobinfosource>`.

.. code-block:: js
   :caption: SomeJobInfoSource.cs
   :emphasize-lines: 6,8,13,14

    using System.Collections.Generic;
    using System.Threading.Tasks;

    using InfinniPlatform.Scheduler.Contract;

    public class SomeJobInfoSource : IJobInfoSource
    {
        public Task<IEnumerable<IJobInfo>> GetJobs(IJobInfoFactory factory)
        {
            var jobs = new[]
                       {
                           // Задание будет выполняться через каждые 5 секунд
                           factory.CreateJobInfo<SomeJobHandler>("SomeJob",
                               b => b.CronExpression(e => e.Seconds(i => i.Each(0, 5))))
                       };

            return Task.FromResult<IEnumerable<IJobInfo>>(jobs);
        }
    }

:doc:`Зарегистрируйте в IoC-контейнере </02-ioc/container-builder>` обработчики и источники заданий приложения.

.. code-block:: js
   :caption: ContainerModule.cs
   :emphasize-lines: 10,11

    using InfinniPlatform.Scheduler.Contract;
    using InfinniPlatform.Sdk.IoC;

    public class ContainerModule : IContainerModule
    {
        public void Load(IContainerBuilder builder)
        {
            var assembly = typeof(ContainerModule).Assembly;

            builder.RegisterJobHandlers(assembly);
            builder.RegisterJobInfoSources(assembly);

            // Прочие зависимости...
        }
    }


.. _`Package Manager Console`: http://docs.nuget.org/consume/package-manager-console