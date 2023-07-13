# php-server:8.2.8
cd php82
docker build . -t registry.gitlab.com/prochazka-dominik/docker/php-server:8.2.8 --no-cache
docker push registry.gitlab.com/prochazka-dominik/docker/php-server:8.2.8
