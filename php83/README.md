# php-server:8.3.7
cd php83
docker build . -t registry.gitlab.com/prochazka-dominik/docker/php-server:8.3.7 --no-cache
docker push registry.gitlab.com/prochazka-dominik/docker/php-server:8.3.7
