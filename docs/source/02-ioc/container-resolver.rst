Разрешение зависимостей
=======================

После :doc:`регистрации </02-ioc/container-builder>` компоненты доступны для получения. Процесс получения
экземпляра одного компонента другим с использованием IoC-контейнера называется **разрешением зависимости**.
В приложениях InfinniPlatform все зависимости передаются через конструкторы классов.


Прямое получение зависимости
----------------------------

В большинстве случаев между компонентами установлена прямая зависимость. В следующем примере компонент ``A``
зависит от компонента ``B``. В тот момент, когда приложению потребуется компонент ``A``, IoC-контейнер сначала
создаст компонент ``B``, а затем передаст созданный экземпляр в конструктор компонента ``A``. Если компонент ``B``
зависит от других компонентов, они будут созданы перед его созданием.

.. code-block:: csharp
   :emphasize-lines: 5

    public class A
    {
        private readonly B _b;
    
        public A(B b)
        {
            _b = b;
        }
    
        public void SomeMethod()
        {
            _b.DoSomething();
        }
    }


Получение списка зависимостей
-----------------------------

В случае, если необходимо получить набор однотипных компонентов, в конструкторе необходимо указать перечисление
нужного типа. В следующем примере компонент ``A`` зависит от всех компонентов типа ``B``. Все компоненты типа ``B``
будут созданы и переданы в конструктор компонента ``A`` в виде перечисления `IEnumerable<T>`_.

.. code-block:: csharp
   :emphasize-lines: 5

    public class A
    {
        private readonly IEnumerable<B> _list;
    
        public A(IEnumerable<B> list)
        {
            _list = list;
        }
    
        public void SomeMethod()
        {
            foreach (var b in _list)
            {
                b.DoSomething();
            }
        }
    }


Отложенное получение звисимости
-------------------------------

В случае, если получение зависимости достаточно ресурсоемкая операция или зависимость нечасто используется,
следует воспользоваться отложенной инициализацией, которая реализована с использованием класса `Lazy<T>`_.
В следующем примере компонент ``A`` зависит от компонента ``B``, но получает эту зависимость через отложенную
инициализацию, при первом обращении к свойству `Lazy<T>.Value`_.     

.. code-block:: csharp
   :emphasize-lines: 5,12

    public class A
    {
        private readonly Lazy<B> _b;
    
        public A(Lazy<B> b)
        {
            _b = b;
        }
    
        public void SomeMethod()
        {
            _b.Value.DoSomething();
        }
    }


.. _resolve-func:

Получение фабричной функции
---------------------------

В случае, если необходимо создать более одного экземпляра зависимости или решение о создании зависимости может быть
принято только на этапе выполнения, следует использовать фабричную функцию. В следующем примере компонент ``A`` зависит
от компонента ``B``, но получает эту зависимость только перед ее использованием.

.. code-block:: csharp
   :emphasize-lines: 5,12

    public class A
    {
        private readonly Func<B> _b;
    
        public A(Func<B> b)
        {
            _b = b;
        }
    
        public void SomeMethod()
        {
            var b = _b();
    
            b.DoSomething();
        }
    }


Получение параметризованной фабричной функции
---------------------------------------------

В случае, если необходимо создать более одного экземпляра зависимости или решение о создании зависимости может быть
принято только на этапе выполнения, и при этом зависимость не может быть создана без указания одного или нескольких
параметров, которые известны только на этапе выполнения, следует использовать параметризованную фабричную функцию.
В следующем примере компонент ``A`` зависит от компонента ``B``, но получает эту зависимость только перед ее
использованием, передав фабричной функции значение параметра, необходимого для создания компонента ``B``.

.. code-block:: csharp
   :emphasize-lines: 5,12

    public class A
    {
        private readonly Func<int, B> _b;
    
        public A(Func<int, B> b)
        {
            _b = b;
        }
    
        public void SomeMethod()
        {
            var b = _b(42);
    
            b.DoSomething();
        }
    }
    
    
    public class B
    {
        public B(int v) { /* ... */ }
    
        public void DoSomething() { /* ... */ }
    }

Если фабричная функция должна принимать несколько однотипных параметров, нужно определить ее делегат.

.. code-block:: csharp
   :emphasize-lines: 5,12,27

    public class A
    {
        private readonly FactoryB _b;
    
        public A(FactoryB b)
        {
            _b = b;
        }
    
        public void SomeMethod()
        {
            var b = _b(42, 43);
    
            b.DoSomething();
        }
    }
    
    
    public class B
    {
        public B(int v1, int v2) { /* ... */ }
    
        public void DoSomething() { /* ... */ }
    }


    public delegate B FactoryB(int v1, int v2);


.. index:: IContainerResolver

.. _container-resolver:

Получение прямого доступа к IoC-контейнеру
------------------------------------------

В случае, если необходимо реализовать универсальную фабрику компонентов, тип которых известен только на этапе
выполнения (например, в случае с generic-типами) или логика работы компонента зависит от конфигурации IoC-контейнера,
можно получить прямой доступ к контейнеру, указав в конструкторе зависимость от интерфейса ``InfinniPlatform.Sdk.IoC.IContainerResolver``.
В следующем примере компонент ``A`` получает доступ к IoC-контейнеру, поскольку тип компонента, от которого он зависит,
становится известен только на этапе выполнения.

.. code-block:: csharp
   :emphasize-lines: 5,12

    public class A
    {
        private readonly IContainerResolver _resolver;
    
        public A(IContainerResolver resolver)
        {
            _resolver = resolver;
        }
    
        public void SomeMethod<T>()
        {
            var b = _resolver.Resolve<B<T>>();
    
            b.DoSomething();
        }
    }
    
    
    public class B<T>
    {
        public void DoSomething() { /* ... */ }
    }


Получение зависимости во время выполнения
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. index:: IContainerResolver.Resolve()

Интерфейс ``InfinniPlatform.Sdk.IoC.IContainerResolver`` позволяет получить зависимость любым, указанным выше
способом. Для этих целей служит метод ``Resolve()``, имеющий две перегрузки.

.. code-block:: csharp

    // Способ 1
    IMyService myService = resolver.Resolve<IMyService>();

    // Способ 2
    object myService = resolver.Resolve(typeof(IMyService));

.. index:: IContainerResolver.TryResolve()

Если сервис не зарегистрирован, метод ``Resolve()`` бросит исключение. Эту ситуацию можно обойти двумя способами.
Первый - с помощью метода ``TryResolve()``.

.. code-block:: csharp

    // Способ 1
    
    IMyService myService;
    
    if (resolver.TryResolve<IMyService>(out myService))
    {
        // ...
    }
    
    // Способ 2
    
    object myService;
    
    if (resolver.TryResolve(typeof(IMyService), out myService))
    {
        // ...
    }

.. index:: IContainerResolver.ResolveOptional()

Второй - с помощью метода ``ResolveOptional()``.

.. code-block:: csharp

    // Способ 1
    
    IMyService myService = resolver.ResolveOptional<IMyService>();
    
    if (myService != null)
    {
        // ...
    }
    
    // Способ 2
    
    object myService = resolver.ResolveOptional(typeof(IMyService));
    
    if (myService != null)
    {
        // ...
    }


.. index:: IContainerResolver.Services
.. index:: IContainerResolver.IsRegistered()

Проверка конфигурации IoC-контейнера
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Для проверки конфигурации IoC-контейнера можно обратиться к списку зарегистрированных сервисов ``Services``.
Для проверки наличия регистрации определенного сервиса следует использовать метод ``IsRegistered()``. 

.. code-block:: csharp

    // Способ 1
    
    if (resolver.IsRegistered<IMyService>())
    {
        // ...
    }
    
    // Способ 2
    
    if (resolver.IsRegistered(typeof(IMyService)))
    {
        // ...
    }


.. _`IEnumerable<T>`: https://msdn.microsoft.com/en-US/library/9eekhta0(v=vs.110).aspx
.. _`Lazy<T>`: https://msdn.microsoft.com/en-US/library/dd642331(v=vs.110).aspx
.. _`Lazy<T>.Value`: https://msdn.microsoft.com/en-US/library/dd642177(v=vs.110).aspx
