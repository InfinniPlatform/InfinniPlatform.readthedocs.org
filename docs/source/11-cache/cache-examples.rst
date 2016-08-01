Пример использования
=====================

.. code-block:: csharp

    public class CacheExample
    {
        public CacheHttpService(ICache cache)
        {
            //Получаем экземпляр кэша в зависимости от настроек приложения см. :doc:`/11-cache/cache-setup`
            _cache = cache;
        }

        private readonly ICache _cache;

        private void SomeMethod()
        {
            //Сохраняем ключ и значение в кэш.
            _cache.Set("key", "value");

        }
    }