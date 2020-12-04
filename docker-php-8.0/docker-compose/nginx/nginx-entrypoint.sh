#!/bin/sh

set -e

cat <<EOF >/etc/nginx/conf.d/default.conf
server {
    listen 80;
    listen [::]:80;

    server_name ${SERVER_NAME} www.${SERVER_NAME};
    charset utf-8;

    root ${DOCKER_NGINX_ROOT_PUBLIC};
    index index.php;

    if (!-e \$request_filename) {
        rewrite ^.*\$ /index.php last;
    }

    location ~ \.php\$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)\$;
        fastcgi_pass ${DOCKER_PHP_SERVICE}:${DOCKER_PHP_SERVICE_PORT};
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_param PATH_INFO \$fastcgi_path_info;
    }

    location ~ /.well-known/acme-challenge {
          allow all;
          root /var/www/html/suite;
    }

}
EOF

# Run nginx
nginx -g "daemon off;"