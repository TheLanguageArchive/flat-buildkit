# syntax=docker/dockerfile:1.5.1
FROM postgres:17.0-alpine

EXPOSE 5432

ENV \
    PGDATA=/var/lib/postgresql/data

COPY --link ./rootfs /