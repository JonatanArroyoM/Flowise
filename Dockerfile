# Build local monorepo image
# docker build --no-cache -t  flowise .

# Run image
# docker run -d -p 3000:3000 flowise

FROM node:18-alpine

# Install required system dependencies
RUN apk add --update libc6-compat python3 make g++
# needed for pdfjs-dist
RUN apk add --no-cache build-base cairo-dev pango-dev

# Install Chromium
RUN apk add --no-cache chromium

# Install PNPM globally
RUN npm install -g pnpm@8.14.0

# Set environment variables for Puppeteer
ENV PUPPETEER_SKIP_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Set the working directory in the container
WORKDIR /usr/src

# Create necessary directory
RUN mkdir -p /opt/render/.flowise/log

# Copy app source
COPY . .

# Install dependencies
RUN pnpm install

# Build the application
RUN pnpm build

# Expose port 3000 for the application
EXPOSE 3000

# Command to start the application
CMD [ "pnpm", "start" ]

