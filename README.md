
# php80-laravel8

## Usage:

This image has been prepared for laravel 8 projects that run on PHP 8.0
To use this image as your base image generate a file that has the name `Dockerfile` and put this piece of code on top of it.

```sh
FROM nozkok/php80-laravel8:8.0.0
```

Then add your custom commands.

In its simplest form you can use this image just like this:

```sh
FROM nozkok/php80-laravel8:8.0.0

COPY ./ /var/www

EXPOSE 8000

CMD ["sh", "-c", "php-fpm"]
```

---

## Extras:

If you want to add `xdebug` to your image add this code to your dockerfile. 

```sh
RUN pecl install xdebug
RUN docker-php-ext-enable xdebug
```

If you want to run supervisor for your laravel worker you can put a supervisor conf file that has `laravel-worker.conf` name to your project as like this:

```sh
[program:laravel-worker]
process_name=%(program_name)s_%(process_num)02d
command=php /var/www/artisan queue:work --sleep=3 --tries=3
autostart=true
autorestart=true
user=root
numprocs=1
redirect_stderr=true
stdout_logfile=/var/www/storage/logs/supervisor-panel-worker.log
```

Finally, your `Dockerfile` should be like to run with supervisord:

```sh
FROM nozkok/php80-laravel8:8.0.0

COPY ./laravel-worker.conf /etc/supervisor/conf.d/
COPY ./ /var/www

EXPOSE 8000

CMD ["sh", "-c", "/usr/bin/supervisord -c /etc/supervisor/supervisord.conf && php-fpm"]
```
