.. index:: AppExtension.json

Настройки приложения
====================

Разработчики и администраторы имеют возможность настраивать приложение InfinniPlatform с помощью **файла конфигурации**.
Файл конфигурации - это текстовый файл с настройками приложения в JSON_-формате. Разработчики могут задавать параметры
в файле конфигурации, которые будут учитываться в коде приложения, таким образом устраняя необходимость в изменении кода
при изменении того или иного параметра. Администраторы, в свою очередь, могут изменять значения нужных параметров в файле
конфигурации, управляя тем самым способом выполнения приложения.


Файл конфигурации приложения
----------------------------

Файл конфигурации приложения представляет собой текстовый файл в кодировке UTF-8_, который хранит настройки приложения в JSON-формате.
Файл конфигурации должен иметь имя ``AppExtension.json`` и находится в рабочем каталоге приложения.

.. note:: Название ``AppExtension.json`` связано с тем, что приложение является своего рода расширением InfinniPlatform.

Сами настройки представляют собой JSON-объект с множеством свойств. Свойства первого уровня вложенности называются **секциями конфигурации**.
Секция конфигурации представляет собой парку "ключ - значение", где ключ - это наименование свойства, а значение - JSON-объект любой сложности.
Каждая секция конфигурации отражает настройки определенной подсистемы InfinniPlatform или определенной части приложения.

Ниже приведен пример общей структуры файла конфигурации приложения. В примере определено две секции - ``section1`` и ``section2`` -
каждая из которых имеет свой набор свойств. Свойства секции конфигурации могут быть любого допустимого JSON-типа (не только строкового,
как приведено в примере). Количество, наименование и содержимое секции конфигурации определяется на прикладном уровне, за исключением
предопределенных в InfinniPlatform секций конфигурации.

.. code-block:: js
   :emphasize-lines: 3,10
   :caption: AppExtension.json

    {
      /* Комментарий для section1 */
      "section1": {
        "Property11": "Value11",
        "Property12": "Value12",
        "Property13": "Value13",
        ...
      },
      /* Комментарий для section2 */
      "section2": {
        "Property21": "Value21",
        "Property22": "Value22",
        "Property23": "Value23",
        ...
      },
      ...
    }


.. index:: IAppConfiguration
.. index:: IAppConfiguration.GetSection()

Чтение настроек приложения
--------------------------

Для чтения настроек приложения из файла конфигурации необходимо :doc:`получить </02-ioc/index>` реализацию интерфейса
``InfinniPlatform.Sdk.Settings.IAppConfiguration`` из IoC-контейнера и вызвать одну из перегрузок метода ``GetSection()``,
передав ему наименование секции конфигурации, которую нужно прочитать.

Допустим в файле конфигурации определена секция ``myComponent``, как в примере ниже. 

.. code-block:: js
   :caption: AppExtension.json

    {
      "myComponent": {
        "Property1": true,
        "Property2": 123,
        "Property3": "Abc"
      },
      ...
    }

Тогда в коде приложения можно выполнить чтение настроек этой секции следующим образом.

.. code-block:: js
   :emphasize-lines: 3,5

    public class MyComponent
    {
        public MyComponent(InfinniPlatform.Sdk.Settings.IAppConfiguration appConfiguration)
        {
            dynamic myComponentSettings = appConfiguration.GetSection("myComponent");
            bool property1 = myComponentSettings.Property1; // true
            int property2 = myComponentSettings.Property2; // 123
            string property3 = myComponentSettings.Property3; // "Abc"
    
            // ...
        }
    
        // ...
    }

В приведенном примере настройки были считаны, как :doc:`динамический объект </01-dynamic/index>`. Однако это не всегда удобно,
поэтому для случаев, когда структура секции конфигурации известна, рекомендуется явно определить класс, описывающий содержимое
секции конфигурации, и использовать строготипизированную перегрузку метода ``GetSection()``.

.. code-block:: js
   :emphasize-lines: 1,11,13

    public class MyComponentSettings
    {
        public bool Property1 { get; set; }
        public int Property2 { get; set; }
        public string Property3 { get; set; }
    }
    
    
    public class MyComponent
    {
        public MyComponent(InfinniPlatform.Sdk.Settings.IAppConfiguration appConfiguration)
        {
            var myComponentSettings = appConfiguration.GetSection<MyComponentSettings>("myComponent");
            bool property1 = myComponentSettings.Property1; // true
            int property2 = myComponentSettings.Property2; // 123
            string property3 = myComponentSettings.Property3; // "Abc"
    
            // ...
        }
    
        // ...
    }


Интеграция с IoC-контейнером
----------------------------

При разработке собственных компонентов намного удобней получать настройки сразу в конструкторе, а не осуществлять чтение
из файла конфигурации. Это позволяет сделать компонент более независимым и избавит от необходимости выполнять дополнительные
действия в конструкторе. Для реализации этого подхода следует модифицировать вышеуказанный пример, переместив логику чтения
секции конфигурации на уровень модуля IoC-контейнера. 

.. code-block:: js
   :emphasize-lines: 3,20-22

    public class MyComponent
    {
        public MyComponent(MyComponentSettings myComponentSettings)
        {
            bool property1 = myComponentSettings.Property1; // true
            int property2 = myComponentSettings.Property2; // 123
            string property3 = myComponentSettings.Property3; // "Abc"
    
            // ...
        }
    
        // ...
    }
    
    
    public class ContainerModule : IContainerModule
    {
        public void Load(IContainerBuilder builder)
        {
            builder.RegisterFactory(r => r.Resolve<IAppConfiguration>().GetSection<MyComponentSettings>("myComponent"))
                   .As<MyComponentSettings>()
                   .SingleInstance();
    
            builder.RegisterType<MyComponent>()
                   .AsSelf()
                   .SingleInstance();
    
            // ...
        }
    }


.. _JSON: http://json.org/
.. _UTF-8: https://tools.ietf.org/html/rfc3629