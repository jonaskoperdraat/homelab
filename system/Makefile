.POSIX:

export KUBECONFIG = $(shell pwd)/../metal/kubeconfig.yaml

env ?= prod
revision ?= master

.PHONY: *

default: bootstrap $(if $(filter dev,$(env)),,external)

bootstrap:
	ansible-playbook \
		--extra-vars env=$(env) \
		--extra-vars revision=$(revision) \
		bootstrap.yml

# The Terraform Cloud workspaces are shared with production, never apply them elsewhere
external:
	@test "$(env)" = prod || { echo "Refusing to apply $@ for env=$(env)"; exit 1; }
	make -C external

