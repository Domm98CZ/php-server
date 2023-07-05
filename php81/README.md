# php-server:8.1.20
cd php81
docker build . -t registry.gitlab.com/prochazka-dominik/docker/php-server:8.1.20 --no-cache
docker push registry.gitlab.com/prochazka-dominik/docker/php-server:8.1.20
