.POSIX:
.PHONY: *
.EXPORT_ALL_VARIABLES:

KUBECONFIG = $(shell pwd)/metal/kubeconfig.yaml
KUBE_CONFIG_PATH = $(KUBECONFIG)

default: metal system platform application smoke-test clean

configure:
	./scripts/configure
	git status

metal:
	make -C metal

system:
	make -C system

platform:
	make -C platform

application:
	make -C application

smoke-test:
	make -C test filter=Smoke

# TODO maybe there's a better way to manage backup with GitOps?
backup:
	./scripts/backup --action setup --namespace=actualbudget --pvc=actualbudget-data
	./scripts/backup --action setup --namespace=jellyfin --pvc=jellyfin-data

restore:
	./scripts/backup --action restore --namespace=actualbudget --pvc=actualbudget-data
	./scripts/backup --action restore --namespace=jellyfin --pvc=jellyfin-data

test:
	make -C test

clean:
	docker compose --project-directory ./metal/roles/pxe_server/files down
	k3d cluster delete homelab-dev

docs:
	mkdocs serve

git-hooks:
	pre-commit install
