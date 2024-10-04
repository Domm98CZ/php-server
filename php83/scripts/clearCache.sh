#!/bin/bash
rm -R /var/www/app/temp/cache/*
pkill -9 php
chmod -R 777 /var/www/app/temp/cache/
