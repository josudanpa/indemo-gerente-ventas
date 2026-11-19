FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
RUN echo 'server { listen 80; root /usr/share/nginx/html; location / { index index.html; add_header Cache-Control "no-cache" always; } }' > /etc/nginx/conf.d/default.conf
EXPOSE 80
