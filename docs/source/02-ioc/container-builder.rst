.. index:: IContainerBuilder

Регистрация компонентов
=======================

Интерфейс ``InfinniPlatform.Sdk.IoC.IContainerBuilder`` предоставляет семейство методов ``Register()``, предназначенных
для регистрации компонентов IoC-контейнера. Методы регистрации также определяют способ создания **экземпляров** компонентов.
Экземпляры компонентов могут быть созданы через reflection_, средствами самого IoC-контейнера; могут быть представлены
заранее созданным экземпляром; могут быть созданы с помощью определенной фабричной функции, в роли которой может выступать
lambda_-выражение. Каждый компонент может предоставлять один или несколько **сервисов**, определенных с использованием
семейства методов ``As()``. 

.. code-block:: csharp
   :emphasize-lines: 16

    public interface IMyService
    {
        // ...
    }
    
    
    public class MyComponent : IMyService
    {
        // ...
    }
    
    public class ContainerModule : InfinniPlatform.Sdk.IoC.IContainerModule
    {
        public void Load(InfinniPlatform.Sdk.IoC.IContainerBuilder builder)
        {
            builder.RegisterType<MyComponent>().As<IMyService>();
    
            // ...
        }
    }


.. index:: IContainerBuilder.RegisterType()

Регистрация типов
-----------------

Экземпляры компонентов, зарегистрированных с помощью метода ``RegisterType()``, создаются с помощью reflection_,
с использованием конструктора с наибольшим количеством параметров, которые могут быть получены из контейнера. 

.. code-block:: csharp

    // Способ 1
    builder.RegisterType<MyComponent>().As<IMyService>();

    // Способ 2
    builder.RegisterType(typeof(MyComponent)).As(typeof(IMyService));


.. index:: IContainerBuilder.RegisterGeneric()

Регистрация generic-типов
-------------------------

Если компонент представлен generic_-типом, для его регистрации следует использовать метод ``RegisterGeneric()``.
Как и в случае с обычными типами, экземпляры generic-компонентов создаются с помощью reflection_ с использованием
конструктора с наибольшим количеством параметров, которые могут быть получены из контейнера.

.. code-block:: csharp
   :emphasize-lines: 7

    public interface IRepository<T> { /* ... */ }

    public class MyRepository<T> : IRepository<T> { /* ... */ }

    // ...

    builder.RegisterGeneric(typeof(MyRepository<>)).As(typeof(IRepository<>));


.. index:: IContainerBuilder.RegisterInstance()

Регистрация экземпляров
-----------------------

В некоторых случаях может возникнуть необходимость зарегистрировать заранее созданный экземпляр компонента.
Например, в случае, если создание компонента является ресурсоемкой или сложной операцией. Для регистрации
таких компонентов следует использовать метод ``RegisterInstance()``.

.. code-block:: csharp

    builder.RegisterInstance(new MyComponent()).As<IMyService>();


.. index:: IContainerBuilder.RegisterFactory()

Регистрация фабричных функций
-----------------------------

Компонент может быть зарегистрирован с помощью определенной фабричной функции или lambda_-выражения. Данный способ
хорошо подходит для ситуаций, когда перед созданием экземпляра компонента необходимо выполнить предварительные
вычисления или компонент невозможно создать, используя конструктор. Для регистрации таких компонентов следует
использовать метод ``RegisterFactory()``. 

.. code-block:: csharp

    builder.RegisterFactory(r => new MyComponent()).As<IMyService>();

Входной параметр ``r`` представляет :ref:`контекст IoC-контейнера <container-resolver>`, через конторый можно
получить все зависимости, необходимые для создания компонента. Этот подход наиболее приемлем, чем получение
ссылок на зависимости через замыкание (closure), поскольку гарантирует единый способ управления жизненным
циклом всех зависимостей.   

.. code-block:: csharp

    builder.RegisterFactory(r => new A(r.Resolve<B>()));


.. _reflection: https://msdn.microsoft.com/en-us/library/f7ykdhsy(v=vs.110).aspx
.. _generic: https://msdn.microsoft.com/en-US/library/512aeb7t.aspx
.. _lambda: https://msdn.microsoft.com/en-US/library/bb397687.aspx