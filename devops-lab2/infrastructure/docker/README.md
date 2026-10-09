# Учебный Docker-образ

```bash
docker build -t devops-lab2:local .
docker run --rm devops-lab2:local
```

Образ использует Alpine Linux с фиксированной версией ветки 3.22.
Команда `echo` выводит `DevOps Lab 2: Docker image works` и завершает
контейнер с кодом 0. Это минимальный проверяемый Dockerfile без сервиса.
`--rm` удаляет завершившийся контейнер; образ остаётся локально.
Очистка образа: `docker image rm devops-lab2:local`.
