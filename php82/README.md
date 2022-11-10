# php-server:8.2.0RC4
cd php82
docker build . -t registry.gitlab.com/prochazka-dominik/docker/php-server:8.2.0RC4 --no-cache
docker push registry.gitlab.com/prochazka-dominik/docker/php-server:8.2.0RC4

# php-server:8.2.0RC5
cd php82
docker build . -t registry.gitlab.com/prochazka-dominik/docker/php-server:8.2.0RC5 --no-cache
docker push registry.gitlab.com/prochazka-dominik/docker/php-server:8.2.0RC5
