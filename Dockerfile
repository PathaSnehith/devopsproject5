##
# Multi-stage Dockerfile for the TalentFlow React app.
# Builds static assets with Node and serves them via Nginx.
##

FROM node:18-alpine AS builder
ENV NODE_ENV=production
WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

FROM nginx:1.27-alpine AS runner
COPY --from=builder /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

