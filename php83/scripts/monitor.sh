#!/bin/bash

echo "=== Apache Processes ==="
ps aux | grep apache2 | grep -v grep | wc -l

echo "=== Memory Usage ==="
free -h

echo "=== Apache Memory Usage ==="
ps aux | grep apache2 | awk '{sum+=$6} END {print "Total Apache memory: " sum/1024 " MB"}'

echo "=== PHP-FPM Status ==="
if pgrep php-fpm > /dev/null; then
    echo "PHP-FPM is running"
else
    echo "PHP-FPM is not running (using mod_php)"
fi

echo "=== Disk Usage ==="
df -h /var/www

echo "=== Load Average ==="
uptime
