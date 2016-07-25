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

Установите утилиту Infinni.Node для развертывания приложений на базе InfinniPlatform
(:download:`скачать скрипт установки Infinni.Node <../_files/Infinni_Node_Install.bat> для Windows`).

По умолчанию устанавливается последняя версия утилиты:

.. code-block:: bash

    > Infinni_Node_Install.bat # устанавливает последнюю версию утилиты Infinni.Node

Однако можно установить любую `доступную версию <http://nuget.infinnity.ru/packages/Infinni.Node/>`_ утилиты: 

.. code-block:: bash

    > Infinni_Node_Install.bat 1.2.0.19-master # устанавливает версию '1.2.0.19-master' утилиты Infinni.Node

После выполнения скрипта утилита Infinni.Node будет установлена в каталог с именем ``Infinni.Node.X.`` (где ``X`` - номер версии утилиты)
на том же уровне, откуда был запущен скрипт установки. Перейдите в этот каталог:

.. code-block:: bash

    > cd Infinni.Node.1.2.0.19-master

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
- Утилита `curl`_
- `Visual Studio Community`_

Для развертывания в Windows
~~~~~~~~~~~~~~~~~~~~~~~~~~~

- Windows Server 2008 R2 SP1 (или SP2) x64, Windows Server 2012 (или 2012 R2) x64
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
.. _curl: https://curl.haxx.se/download.html
.. _Visual Studio Community: https://www.visualstudio.com/ru-ru/products/visual-studio-community-vs.aspx
.. _Microsoft .NET Framework 4.5: https://www.microsoft.com/ru-ru/download/details.aspx?id=30653
.. _Mono 4.2: http://www.mono-project.com/download/
.. _MongoDB: https://www.mongodb.com/download-center
.. _RabbitMQ: https://www.rabbitmq.com/download.html
.. _Redis: http://redis.io/download
.. _ELK: https://www.elastic.co/products
