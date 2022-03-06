# # Build the image
# FROM node:12-alpine as builder

# #  set working directory
# WORKDIR /usr/local/app

# ENV PATH /usr/src/app/node_modules/.bin:$PATH

# # COPY json package files
# COPY package.json .

# # Install Node modules
# RUN npm install

# COPY . .

# RUN npm run build

# # Serve the content
# FROM nginx:alpine

# # set working directory to nginx asset directory
# WORKDIR /usr/share/nginx/html

# # remove default assets
# RUN rm -rf ./*

# # Copy static assets from the builder stage
# COPY --from=builder /app/dist/inventory-mgmt .


# EXPOSE 80
# #  Run container
# ENTRYPOINT ["nginx", "-g", "daemon off"]


FROM node:14.1-alpine AS builder

WORKDIR /usr/local/app
COPY package.json package-lock.json ./
RUN npm install

ENV PATH="./node_modules/.bin:$PATH"

COPY . ./
RUN ng build --prod

FROM nginx:1.17-alpine
COPY nginx.config /etc/nginx/conf.d/default.conf
COPY --from=builder /usr/local/app/dist/inventory-mgmt /usr/share/nginx/html