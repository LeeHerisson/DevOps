# Отчёт: лабораторная работа №2

Дата: 9 октября 2026 года.
Репозиторий для сдачи: https://github.com/LeeHerisson/DevOps (public).

## Что сделано

Конфигурации намеренно простые и не содержат прикладного сервиса.
Dockerfile действительно собирается и выводит сообщение. Terraform использует
встроенный `terraform_data` без облачных ресурсов; Ansible выполняет `debug`;
Kubernetes содержит Deployment с `sleep` и демонстрационный Service;
Prometheus собирает собственные метрики.

## Git-требования

| Требование | Подтверждение |
| --- | --- |
| Минимум 15 коммитов | 20 новых содержательных коммитов на момент слияния PR #3, без учёта merge-коммитов и первой лабораторной; команда подсчёта ниже |
| Минимум 3 feature-ветки | `feature/lab2-foundation`, `feature/lab2-infrastructure`, `feature/lab2-ci-docs` |
| Минимум 2 merged PR | PR #1, #2 и #3 слиты после успешных проверок |
| Разрешённый конфликт | Merge commit `9c312803d276ed6c106f8e5d2fc6d599682e7919` |
| .gitignore | После выполнения лабораторной оба .gitignore удалены из репозитория по просьбе владельца. Правила перенесены в локальный .git/info/exclude и не передаются при клонировании; наличие .gitignore в сдаваемом репозитории больше не выполнено |
| Понятные commit messages | Сообщения описывают конкретное изменение: `feat(terraform)`, `docs(deployment)`, `ci(lab2)` и т. д. |
| Описательные ветки и PR | Названия отражают назначение; PR содержат результат, проверки и ограничения примеров |

Изначальные два коммита первой лабораторной сохранены. История не переписана,
пустые коммиты не использовались, даты не менялись. Файлы `.DS_Store`, которые
были отслеживаемыми раньше, убраны из индекса Git. Затем оставшиеся локальные
копии удалены с диска по просьбе владельца. Старые коммиты сохранены.
Учебные материалы первой лабораторной не изменены.

## Pull Requests

1. [PR #1 — основа проекта, Docker и Terraform](https://github.com/LeeHerisson/DevOps/pull/1): 7 содержательных коммитов.
2. [PR #2 — инфраструктурные примеры](https://github.com/LeeHerisson/DevOps/pull/2): 7 содержательных коммитов.
3. [PR #3 — CI, deployment и разрешение конфликта](https://github.com/LeeHerisson/DevOps/pull/3): 6 содержательных коммитов и merge commit разрешения конфликта.

При слиянии используется **Create a merge commit**, чтобы сохранить отдельные
коммиты. Feature-ветки сохранены на GitHub для проверки преподавателем.

## Разрешение конфликта

Это намеренный учебный конфликт для выполнения задания. Ветки инфраструктуры
и CI создавались от общей точки `ccdd2fb8169a799c81f6b9d3afca5e31624525a9`.
В обеих ветках изменена строка основного сценария и добавлены разные разделы
в конце `devops-lab2/infrastructure/README.md`.

После слияния PR #2 в main выполнено:

```bash
git switch feature/lab2-ci-docs
git fetch origin
git merge --no-ff origin/main
```

Git сообщил `CONFLICT (content)` в README. Конфликт разрешён вручную:
общее описание перечисляет все инструменты, разделы Ansible/Kubernetes/Monitoring
и CI/deployment сохранены, маркеры конфликта удалены. Изменение закоммичено
как merge commit с двумя родителями `6d4013a` и `09a977b`:

[9c312803 — resolve README conflict and preserve both guides](https://github.com/LeeHerisson/DevOps/commit/9c312803d276ed6c106f8e5d2fc6d599682e7919).

Проверка результата, отличающегося от обеих версий:

```bash
git show --remerge-diff 9c312803 -- devops-lab2/infrastructure/README.md
git show --format=raw --no-patch 9c312803
```

## Проверки и бонусы

- Локально: Terraform 1.9.8 — fmt, init, validate и plan успешно.
- Локально: Ansible syntax-check и debug-playbook успешно, `changed=0`, `failed=0`.
- YAML-файлы успешно разобраны; selector Deployment/Service совпадают с labels pod.
- [Успешный GitHub Actions run](https://github.com/LeeHerisson/DevOps/actions/runs/37883365679): YAML, Terraform, Ansible, Docker build/run, promtool.
- [Документация по deployment и очистке](DEPLOYMENT.md).
- Branch protection для main включён: PR, обязательная проверка `validate`, актуальная main перед слиянием, разрешённые обсуждения, запрет force-push и удаления.

Для учебного репозитория обязательное одобрение другим пользователем не задано
(0 approvals), поскольку автор работает один. Администратор сохраняет возможность
обхода правил (`enforce_admins=false`); обычные push подчиняются защите.

Последние запуски CI: [Actions — Lab 2 CI](https://github.com/LeeHerisson/DevOps/actions/workflows/ci.yml).
Kubernetes-кластер не создавался; CI проверяет YAML-синтаксис, а не реальный deployment.

## Проверка результата лабораторной на момент слияния PR #3

```bash
git fetch origin
git switch main
git merge --ff-only origin/main

# Новые содержательные коммиты лабораторной: 20
git rev-list --no-merges --count 6d84520..07d2d11

# Новая история вместе со слияниями: 24; всего в репозитории: 26
git rev-list --count 6d84520..07d2d11
git rev-list --count 07d2d11
git log --oneline --graph --all
git branch -r --list 'origin/feature/lab2-*'

# GitHub CLI с авторизацией владельца
gh pr list --repo LeeHerisson/DevOps --state merged
gh run list --repo LeeHerisson/DevOps --workflow ci.yml
gh api repos/LeeHerisson/DevOps/branches/main/protection
```

## Содержание

Полное описание: [infrastructure/README.md](infrastructure/README.md).
Workflow хранится в `.github/workflows/ci.yml` в корне репозитория,
поскольку вложенный workflow GitHub Actions не обнаруживает.
