# Запуск учебных примеров

Все команды ниже выполняются из корня репозитория, если явно не указан `cd`.
У примеров нет общего прикладного сервиса; каждый инструмент демонстрируется
отдельно. Запуск необязателен для ознакомления со структурой.

## 1. Docker

Запустите Docker Desktop или Docker Engine, затем:

```bash
docker build -t devops-lab2:local devops-lab2/infrastructure/docker
docker run --rm devops-lab2:local
docker image rm devops-lab2:local
```

Вывод: `DevOps Lab 2: Docker image works`. После `--rm` контейнер удаляется.

## 2. Terraform

```bash
cd devops-lab2/infrastructure/terraform
cp terraform.tfvars.example terraform.tfvars
terraform init -backend=false
terraform fmt -check
terraform validate
terraform plan
terraform apply
terraform output
terraform destroy
cd ../../..
```

`apply` и `destroy` запрашивают подтверждение в терминале. Ресурс
`terraform_data` изменяет только локальный state. Облачный аккаунт не нужен.
В исходном локальном checkout собственные `.tfvars`, `.terraform/` и state
игнорируются через `.git/info/exclude`. После нового клонирования эти локальные
правила нужно добавить самостоятельно перед созданием state и личных переменных:

```bash
cat >> .git/info/exclude <<'EOF'
.DS_Store
.gitignore
**/.terraform/*
*.tfstate
*.tfstate.*
*.tfplan
*.tfvars
*.tfvars.json
.env
.env.*
!.env.example
*.pem
*.key
EOF
```

Команда настройки выполняется из корня репозитория.

## 3. Ansible

```bash
ansible-playbook -i devops-lab2/infrastructure/ansible/inventory.ini \
  devops-lab2/infrastructure/ansible/playbook.yml --syntax-check
ansible-playbook -i devops-lab2/infrastructure/ansible/inventory.ini \
  devops-lab2/infrastructure/ansible/playbook.yml
```

Playbook выполняет `debug` на localhost. Он не требует root, SSH-ключей
или внешних коллекций и не меняет систему.

## 4. Kubernetes (при наличии локального кластера)

Проверьте контекст `kubectl config current-context`, выберите свой локальный
кластер (например, minikube) и используйте отдельный namespace:

```bash
kubectl create namespace devops-lab2
kubectl apply -n devops-lab2 -f devops-lab2/infrastructure/kubernetes/
kubectl rollout status -n devops-lab2 deployment/devops-lab2
kubectl get pods,services -n devops-lab2
kubectl delete namespace devops-lab2
```

Pod запускает `sleep 3600`, затем перезапускается. Service — заглушка:
selector совпадает с labels, но на targetPort 8080 никто не слушает.
HTTP-проверка Service не предусмотрена. Не подставляйте образ с `echo`
в Deployment: он немедленно завершится.

## 5. Prometheus (отдельный пример)

```bash
docker run --rm --name devops-lab2-prometheus \
  -p 127.0.0.1:9090:9090 \
  -v "$PWD/devops-lab2/infrastructure/monitoring/prometheus.yml:/etc/prometheus/prometheus.yml:ro" \
  prom/prometheus:v3.2.1
```

Откройте http://localhost:9090, выполните запрос `up`: target `prometheus`
должен иметь значение 1. Завершение — `Ctrl+C`; `--rm` удалит контейнер.
Этот конфиг собирает только метрики самого Prometheus.

## CI и диагностика

В GitHub вкладка **Actions → Lab 2 CI** показывает проверки YAML, Terraform,
Ansible, Docker и Prometheus. В CI выполняется `terraform plan`, а не `apply`.
Kubernetes-кластер в CI не создаётся; для манифестов проверяется YAML-синтаксис.

- `Cannot connect to the Docker daemon`: запустите Docker Desktop/Engine.
- `terraform: command not found`: установите Terraform указанной версии.
- Ошибка контекста kubectl: подключите локальный кластер перед `apply`.
- Ошибка порта 9090: остановите прежний контейнер или выберите другой host-порт.
