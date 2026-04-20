# Makefile for managing the application

.PHONY: up down logs clean build

up:
	docker-compose up -d

down:
	docker-compose down

logs:
	docker-compose logs -f

clean:
	docker-compose down -v
	docker system prune -f

build:
	docker-compose build