# php-server:8.4.1
cd php84
docker build . -t registry.gitlab.com/prochazka-dominik/docker/php-server:8.4.1 --no-cache
docker push registry.gitlab.com/prochazka-dominik/docker/php-server:8.4.1
