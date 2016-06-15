Начало работы
=============

Данная статья поможет сделать необходимые предустановки для начала разработки на базе InfinniPlatform.

Пример приложения
-----------------

Склонируйте пример приложения:

.. code-block:: bash

    > git clone https://github.com/InfinniPlatform/InfinniPlatform.Northwind.git

Откройте файл решения ``InfinniPlatform.Northwind.sln`` в Visual Studio и запустите его на выполнение (``F5``).

Проверьте работоспособность приложения:

.. code-block:: bash

    > curl http://localhost:9900

Пример развертывания
--------------------

Установите утилиту для развертывания приложений InfinniPlatform:

.. code-block:: bash

    > nuget install "Infinni.Node" -Version "1.0.9.5-master" -OutputDirectory "packages" -NonInteractive -Prerelease -Source "http://nuget.org/api/v2;http://nuget.infinnity.ru/api/v2"
    > powershell -NoProfile -ExecutionPolicy Bypass -Command ".\packages\Infinni.Node.1.0.9.5-master\lib\net45\Install.ps1"
    > rd /s /q packages
    > cd Infinni.Node.1.0.9.5-master

Установите нужную версию своего приложения:

.. code-block:: bash

    > Infinni.Node.exe install -i "InfinniPlatform.Northwind" -p

Запустите нужную версию своего приложения:

.. code-block:: bash

    > Infinni.Node.exe start -i "InfinniPlatform.Northwind"

Проверьте работоспособность приложения:

.. code-block:: bash

    > curl http://localhost:9900

Необходимые предустановки
-------------------------

Для разработчика
~~~~~~~~~~~~~~~~

- Клиент `Git`_
- Клиент `NuGet`_
- `Visual Studio Community`_

Для развертывания в Windows
~~~~~~~~~~~~~~~~~~~~~~~~~~~

- Windows Server 2008 R2 SP1 x64 или Windows Server 2008 SP2 x64
- `Microsoft .NET Framework 4.5`_

Для развертывания в Linux
~~~~~~~~~~~~~~~~~~~~~~~~~

- Ubuntu 14.04.4 LTS x64
- `Mono 4.2`_

Дополнительное окружение
~~~~~~~~~~~~~~~~~~~~~~~~

- `MongoDB`_ (при использовании хранилища документов)
- `RabbitMQ`_ (при использовании шины сообщений)  
- `Redis`_ (при развертывании в кластере)
- `ELK`_ (для мониторинга и диагностики)

.. _Git: https://git-scm.com/downloads
.. _Nuget: https://dist.nuget.org/index.html
.. _Visual Studio Community: https://www.visualstudio.com/ru-ru/products/visual-studio-community-vs.aspx
.. _Microsoft .NET Framework 4.5: https://www.microsoft.com/ru-ru/download/details.aspx?id=30653
.. _Mono 4.2: http://www.mono-project.com/download/
.. _MongoDB: https://www.mongodb.com/download-center
.. _RabbitMQ: https://www.rabbitmq.com/download.html
.. _Redis: http://redis.io/download
.. _ELK: https://www.elastic.co/products