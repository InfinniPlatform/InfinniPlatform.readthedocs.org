Генератор представлений
=======================

InfinniPlatform включает в себя механизм генерации представлений. Его суть состоит в том, что он получает **шаблон** и **модель данных** (опционально),
на основе которых формирует HTML-документ. На текущий момент поддерживается только `разметка Razor <http://www.w3schools.com/aspnet/razor_intro.asp>`_.

Razor
~~~~~

Можно использовать представления на основе разметки `Razor <http://www.w3schools.com/aspnet/razor_intro.asp>`_.
Работа с Razor-представлеаниями осуществляется посредством реализации интерфейса ``IHttpService``, которая возвращает экземпляры класса ``ViewHttpResponse``.
Пример:

.. code-block:: csharp

    public class RazorViewsHttpService : IHttpService
    {
        public void Load(IHttpServiceBuilder builder)
        {
            builder.ServicePath = "/razor";
            // Возвращаем Razor-представление Index.cshtml, передавая динамическую модель данных.
            builder.Get["/Index"] = httpRequest =>
                                    {
                                        var viewHttpResponce = new ViewHttpResponce("Index", new DynamicWrapper
                                                                                             {
                                                                                                 { "Title", "Title" },
                                                                                                 { "Data1", "Somedata" },
                                                                                                 { "Data2", DateTime.Now }
                                                                                             });

                                        return Task.FromResult<object>(viewHttpResponce);
                                    };

            // Возвращаем Razor-представление About.cshtml, не принимающее модель данных.
            builder.Get["/About"] = httpRequest => Task.FromResult<object>(new ViewHttpResponce("About"));
        }
    }

Пример Razor-представления:

.. code-block:: html

    @{
    }

    <!-- Для получения доспута к модели данных используется переменная @Model -->
    <h2>@Model["Title"]</h2>
    <p>'Index' view successfully loaded.</p>
    <p>Data1 field = @Model["Data1"]</p>
    <p>Data2 field = @Model["Data2"]</p>