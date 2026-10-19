.POSIX:

export KUBECONFIG = $(shell pwd)/../metal/kubeconfig.yaml

env ?= prod
revision ?= master

.PHONY: *

default: bootstrap

bootstrap:
	ansible-playbook \
		--extra-vars env=$(env) \
		--extra-vars revision=$(revision) \
		bootstrap.yml
