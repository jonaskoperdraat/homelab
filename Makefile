.POSIX:
.PHONY: *
.EXPORT_ALL_VARIABLES:

# Environment, see environments/*.yml. `make env=dev` runs a local k3d cluster
# that follows the current branch (push it first), production follows master.
env ?= prod
revision ?= $(if $(filter dev,$(env)),$(shell git rev-parse --abbrev-ref HEAD),master)

# Separate files, so the dev cluster never overwrites the production kubeconfig
KUBECONFIG = $(shell pwd)/metal/kubeconfig$(if $(filter dev,$(env)),-dev,).yaml
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

# The dev CA is not in the macOS keychain, so skip TLS verification on dev
smoke-test:
	INSECURE_SKIP_VERIFY=$(if $(filter dev,$(env)),1,) make -C test filter=Smoke

# Point the cluster at another branch, e.g. `make env=dev switch revision=my-feature`
switch:
	make -C system bootstrap
	make -C platform bootstrap
	make -C application bootstrap

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
ifeq ($(env),dev)
	@echo "Keeping the k3d cluster, delete it with: k3d cluster delete homelab-dev"
else
	docker compose --project-directory ./metal/roles/pxe_server/files down
endif

docs:
	mkdocs serve

git-hooks:
	pre-commit install
