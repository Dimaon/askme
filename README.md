# Аналог сайта ask.fm на Ruby on Rails

## Краткое описание

Приложение позволяет задавать вопросы и получать на них один ответ.

В приложении реализована возможность использовать хэштеги как в теле вопроса, так и ответа. А также есть быстрый поиск по всем хэштегам.

# Используемые технологии:
 
  - [reCaptcha](https://www.google.com/recaptcha/intro/v3beta.html) от Google

# Установка и запуск

Перед запуском приложения необходимо выполнить установку всех необходимых гемов и подготовку базы данных. Для этого в консоли в директории с приложением необходимо выполнить команды:

    bundle
    rails db:migrate

Также необходимо настроить переменные окружения:

    RECAPTCHA_ASKME_PRIVATE_KEY
    RECAPTCHA_ASKME_PUBLIC_KEY
    
 Рабочий проект расположен на хероку по адресу: [https://askmedimaon.herokuapp.com/](https://askmedimaon.herokuapp.com/)
 
 Автор приложения: [Куликов Дмитрий](https://dimaon.github.io/cv/)
