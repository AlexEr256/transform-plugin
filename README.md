# host transformer plugin (Kong)

Dockerfile - для внесения go-кода в образ конга

docker-compose - запуск postgres и kong вместе

kong-transformer.go - код плагина.

## Процесс тестирования плагина

Создаем сервис и роут (/bash/create.sh)

Отправляем запрос на localhost:8001 (KONG_ADMIN), убеждаемся что плагин доступен для использования.
![Кастомный плагин загружен](./png/plugin_loaded.png)

Проверяем, что сервис и роут созданы.

![Сервис создан](./png/service_created.png)

![Роут создан](./png/route_created.png)

Проверим, что роут api/users?page=2 созданного сервиса возвращает ответ. Для этого воспользуемся  localhost:8000 (KONG_PROXY) 

![Ответ сервиса](./png/service_response.png)

Теперь создадим плагин kong-transformer для нашего сервиса

![Плагин создан](./png/plugin_created.png)

Вновь проверим ответ роута с помощью KONG_PROXY

![Ответ сервиса](./png/again_response.png)

Поскольку у petstore.swagger.io:443 нет роута api/users должно вернуть 404.
