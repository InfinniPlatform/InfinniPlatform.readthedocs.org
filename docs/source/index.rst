Документация InfinniPlatform
============================

.. image:: _images/logo.png

InfinniPlatform - это высокоуровневое решение, предназначенное для быстрой разработки современных
и высокопроизводительных программных продуктов. InfinniPlatform предлагает разработчику единое,
целостное решение, охватывающее большую часть проблем, с которыми можно столкнуться при решении
прикладных задач. InfinniPlatform это не просто высокоуровневый framework, это в первую очередь
готовая инфраструктура, которая упрощает не только процесс разработки, но и развертывания. Стек
решений InfinniPlatform включает специализированные средства, которые позволяют автоматизировать
процесс развертывания приложений в кластерной инфрастурктуре и удобным образом администрировать
различные версии ваших приложений.

InfinniPlatform является проектом с открытым исходным кодом и разрабатывается на базе .NET Framework.
При этом решение является кроссплатформенным и способно работать под Linux/Mono. В основе решения
лежат самые современные средства и технологии. Вот список основных продуктов, которые мы используем
в своем решении: MongoDB_, RabbitMQ_, Redis_, ELK_.

InfinniPlatform предоставляется по лицензии AGPLv3_. Это значит, что вы можете использовать это
решение абсолютно бесплатно и без ограничений. Более того, те программные продукты, которые мы
используем, также являются бесплатными и свободными в использовании.

.. toctree::
   :maxdepth: 2

   00-getting-started/index.rst
   01-dynamic/index.rst
   02-ioc/index.rst
   03-hosting/index.rst
   04-settings/index.rst
   05-logging/index.rst
   06-serialization/index.rst
   07-services/index.rst
   08-document-storage/index.rst
   09-document-services/index.rst
   10-blob-storage/index.rst
   11-cache/index.rst
   12-queues/index.rst
   13-static-files/index.rst
   14-view-engine/index.rst
   15-print-view/index.rst
   16-security/index.rst
   17-scheduler/index.rst
   18-deploy/index.rst
   release-notes/index.rst

Указатель и содержание
======================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`

.. _MongoDB: https://www.mongodb.com/download-center
.. _RabbitMQ: https://www.rabbitmq.com/download.html
.. _Redis: http://redis.io/download
.. _ELK: https://www.elastic.co/products
.. _AGPLv3: https://raw.githubusercontent.com/InfinniPlatform/InfinniPlatform/master/LICENSE
