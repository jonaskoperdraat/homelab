.POSIX:

env ?= prod
revision ?= master

export KUBECONFIG = $(shell pwd)/../metal/kubeconfig$(if $(filter dev,$(env)),-dev,).yaml

.PHONY: *

default: bootstrap

bootstrap:
	ansible-playbook \
		--extra-vars env=$(env) \
		--extra-vars revision=$(revision) \
		bootstrap.yml
