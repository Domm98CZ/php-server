# php-server:8.1.18
cd php81
docker build . -t registry.gitlab.com/prochazka-dominik/docker/php-server:8.1.18 --no-cache
docker push registry.gitlab.com/prochazka-dominik/docker/php-server:8.1.18
