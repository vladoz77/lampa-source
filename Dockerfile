FROM node:24-alpine3.21 AS builder

WORKDIR /app

# Устанавливаем Gulp CLI
RUN npm install -g gulp-cli

COPY package.json ./
RUN npm install

COPY . ./

RUN gulp merge && gulp pack_github

FROM nginx:alpine

RUN rm -rf /etc/nginx/conf.d/default.conf

COPY nginx-lampa.conf /etc/nginx/conf.d/lampa.conf

COPY --from=builder /app/build/github/lampa /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]