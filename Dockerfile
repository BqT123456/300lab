FROM node:20-alpine as build
# Install app dependencies using PNPM
RUN npm install -g pnpm

WORKDIR /app
COPY pnpm*.yaml package*.json ./
RUN pnpm i
COPY . .
RUN pnpm run build

FROM nginx:stable-alpine
COPY --from=build /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 80 
CMD ["nginx", "-g", "daemon off;"]