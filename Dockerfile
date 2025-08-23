FROM nginx:alpine
# Remove default NGINX index if present
RUN rm -f /usr/share/nginx/html/index.html
# Copy your app
COPY index.html /usr/share/nginx/html/index.html
# (Optional) If you later add /assets etc., copy the whole folder:
# COPY . /usr/share/nginx/html/
