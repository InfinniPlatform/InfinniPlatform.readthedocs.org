Администрирование планировщика заданий
======================================

Планировщик заданий InfinniPlatform предоставляет несколько аспектов администрирования.


.. _job-instance:

Журнал планировщика заданий
---------------------------

Каждый экземпляр задания обрабатывается один раз на одном из узлов кластера, при этом сам факт обработки задания
фиксируется в **журнале планировщика заданий** в рамках :doc:`постоянного хранилища </08-document-storage/index>`.
Каждая запись журнала имеет уникальный идентификатор, который совпадает с
:ref:`уникальным идентификатором экземпляра задания <job-handler-context>`,
а также дополнительную информацию, связанную с его обработкой.


.. index:: SchedulerSettings

Конфигурация планировщика заданий
---------------------------------

Ниже приведен пример настройки планировщика заданий InfinniPlatform в :doc:`файле конфигурации приложения </04-settings/index>`.

.. code-block:: js
   :caption: AppExtension.json

    "scheduler": {
      "ExpireHistoryAfter": null
    }

На данный момент конфигурация содержит единственную настройку - атрибут ``ExpireHistoryAfter``, с помощью которого можно определить
максимальное время хранения информации (в секундах) о вызове обработчиков заданий в :ref:`журнале планировщика заданий <job-instance>`.
По умолчанию значение данного атрибута не задано (``null``) и время хранения записей журнала не ограничено.

Автоматическую очистку журнала можно реализовать, указав значение атрибута ``ExpireHistoryAfter``. Следующая конфигурация определяет,
что журнал должен содержать информацию только за последние сутки (24 часа = 86400 секунд).

.. code-block:: js
   :caption: AppExtension.json

    "scheduler": {
      "ExpireHistoryAfter": 86400
    }


REST-сервис планировщика заданий
--------------------------------

Планировщик заданий InfinniPlatform предоставляет административный REST-сервис, позволяющий контролировать состояние планировщика
во время работы приложения, а также управлять заданиями. В целях обеспечения безопасности вызов сервисов возможен только с узла,
на котором работает экземпляр приложения (``localhost``). Ниже приведена краткая информация по каждому из методов сервиса.

.. http:get:: /scheduler/

    Определяет, запущен ли планировщик заданий, а также возвращает количество запланированных и приостановленных заданий.

    :resheader Content-Type: application/json
    :statuscode 200: Нет ошибок

.. http:get:: /scheduler/jobs

    Возвращает список заданий, находящихся в указанном состоянии.

    :query string state: Опциональный. Одно из двух значение: ``planned`` или ``paused``.
    :query int skip: Опциональный. По умолчанию - ``0``.
    :query int take: Опциональный. По умолчанию - ``10``.
    :resheader Content-Type: application/json
    :statuscode 200: Нет ошибок

.. http:get:: /scheduler/jobs/(string:id)

    Возвращает :doc:`информацию об указанном задании </17-scheduler/scheduler-jobinfo>`.

    :param string id: Уникальный идентификатор задания.
    :resheader Content-Type: application/json
    :statuscode 200: Нет ошибок

.. http:post:: /scheduler/jobs/(string:id)

    :ref:`Добавляет или обновляет <add-or-update-job>` указанное задание.

    :param string id: Уникальный идентификатор задания.
    :form body: :doc:`Информация о задании </17-scheduler/scheduler-jobinfo>`.
    :reqheader Content-Type: application/json
    :resheader Content-Type: application/json
    :statuscode 200: Нет ошибок

.. http:delete:: /scheduler/jobs/(string:id)

    :ref:`Удаляет <delete-job>` указанное задание.

    :param int id: Уникальный идентификатор задания.
    :resheader Content-Type: application/json
    :statuscode 200: Нет ошибок

.. http:post:: /scheduler/pause

    :ref:`Приостанавливает планирование <pause-job>` указанных заданий.

    :query string ids: Опциональный. Уникальные идентификаторы заданий через ``,``.
    :resheader Content-Type: application/json
    :statuscode 200: Нет ошибок

.. http:post:: /scheduler/resume

    :ref:`Возобновляет планирование <resume-job>` указанных заданий.

    :query string ids: Опциональный. Уникальные идентификаторы заданий через ``,``.
    :resheader Content-Type: application/json
    :statuscode 200: Нет ошибок

.. http:post:: /scheduler/trigger

    :ref:`Вызывает досрочное выполнение <trigger-job>` указанных заданий.

    :query string ids: Опциональный. Уникальные идентификаторы заданий через ``,``.
    :form body: Данные для выполнения задания.
    :reqheader Content-Type: application/json
    :resheader Content-Type: application/json
    :statuscode 200: Нет ошибок
