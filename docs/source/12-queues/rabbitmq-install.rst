Установка и настройка RabbitMQ
==============================

Установка RabbitMQ
------------------

#. Скачать и установить `Erlang OTP 19.0 Windows 64-bit Binary File <http://www.erlang.org/download.html>`_.
#. Скачать и установить `RabbitMQ Server <https://www.rabbitmq.com/download.html>`_.
#. RabbitMQ Server готов к использованию.

Инструкции на официальном сайте `для Windows <https://www.rabbitmq.com/install-windows.html>`_ и `для Ubuntu/Debian <https://www.rabbitmq.com/install-debian.html>`_

Включение Management Plugin
---------------------------

Для управления и мониторинга состояния RabbitMQ существует специальный плагин.
Для его включения необходимо из папки :file:`C:\\Program Files\\RabbitMQ Server\\rabbitmq_server-3.6.2\\sbin` выполнить команду:

.. code-block:: bash

    > rabbitmq-plugins enable rabbitmq_management

По адресу `http://localhost:15672 <http://localhost:15672>`_ будет доступен сайт Management API.

`Инструкции на официальном сайте <https://www.rabbitmq.com/management.html>`_

Настройки RabbitMQ в AppCommon.json
-----------------------------------

Пример конфигурации:

.. code-block:: javascript

    "rabbitmq": {
      "HostName": "localhost",
      "Port": 5672,
      "UserName": "guest",
      "Password": "guest",
      "ManagementApiPort": 15672
    }

* *HostName* - имя сервера, где установлен RabbitMQ
* *Port* - номер порта для доступа к RabbitMQ
* *UserName* - имя пользователя RabbitMQ
* *Password* - пароль пользователя RabbitMQ
* *ManagementApiPort* - номер порта для доступа к Management API