# ---- build stage ----
FROM node:18-alpine AS build
WORKDIR /app

# copy package files first for caching
COPY package*.json ./
RUN npm ci --silent

# copy all project files and build
COPY . .
RUN npm run build

# ---- production stage ----
FROM nginx:alpine AS production

# Optional: custom nginx config to support SPA routing
COPY nginx.conf /etc/nginx/conf.d/default.conf

# copy built files from the build stage
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
