# Лабораторная работа №2: Git и структура DevOps-проекта

Учебные конфигурации для знакомства с Git, Docker, Terraform, Ansible,
Kubernetes, Prometheus и GitHub Actions. Файлы намеренно минимальные:
проект не содержит прикладного сервиса и не создаёт облачных ресурсов.

Основной сценарий: Docker и GitHub Actions.

## Структура

```text
DevOps/
├── .github/workflows/ci.yml     # GitHub ищет workflow в корне репозитория
├── .gitignore
├── devops-lab1/                # первая лабораторная
└── devops-lab2/infrastructure/
    ├── terraform/             # terraform_data без внешних провайдеров
    ├── ansible/               # локальный playbook с debug
    ├── kubernetes/            # учебные Deployment и Service
    ├── docker/                # образ, печатающий сообщение
    ├── monitoring/            # Prometheus собирает собственные метрики
    ├── .gitignore
    └── README.md
```

Workflow из исходного вложенного шаблона перенесён в `.github/workflows/ci.yml`
в корне Git-репозитория: только там GitHub Actions обнаруживает workflow.
См. [официальную документацию](https://docs.github.com/en/actions/concepts/workflows-and-actions/workflows).

## Инструменты

- Git и доступ к GitHub.
- Docker Engine или запущенный Docker Desktop — для сборки образа.
- Terraform >= 1.4, < 2.0 — для учебного ресурса `terraform_data`.
- Ansible Core — для playbook; внешние коллекции не нужны.
- kubectl и локальный кластер — только для применения Kubernetes-примеров.

## Docker

Из корня репозитория:

```bash
docker build -t devops-lab2:local devops-lab2/infrastructure/docker
docker run --rm devops-lab2:local
```

Ожидаемый вывод: `DevOps Lab 2: Docker image works`.
Контейнер завершается с кодом 0; сервер и открытый порт ему не нужны.

## Terraform

```bash
cd devops-lab2/infrastructure/terraform
terraform fmt -check
terraform init -backend=false
terraform validate
terraform plan
```

`terraform_data` хранит учебные данные в локальном state. Он не запускает
контейнеры, виртуальные машины или платные ресурсы. State и личные tfvars
исключены из Git. Для запуска и очистки см. документацию по deployment.

## Работа с Git

Изменения оформляются небольшими содержательными коммитами в ветках
`feature/lab2-foundation`, `feature/lab2-infrastructure` и `feature/lab2-ci-docs`.
Для слияний используется merge commit, чтобы сохранить все исходные коммиты.
Feature-ветки сохраняются на GitHub для проверки лабораторной.

```bash
git log --oneline --graph --all
git rev-list --count main -- devops-lab2 .github .gitignore README.md
git branch -a
```

Историю PR и описание разрешённого учебного конфликта см. в отчёте
`devops-lab2/REPORT.md` после завершения работы.

## CI и deployment

Workflow `.github/workflows/ci.yml` запускается при push в `main` и
`feature/lab2-*`, при PR в `main` и вручную через Actions.
Job `validate` проверяет YAML, Terraform fmt/validate/plan, Ansible,
сборку и вывод Docker-образа, а также конфигурацию Prometheus через promtool.
Workflow не развёртывает облако и не требует repository secrets.

Подробные команды запуска и очистки:
[DEPLOYMENT.md](../DEPLOYMENT.md).
