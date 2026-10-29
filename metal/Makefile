.POSIX:

env ?= prod
export KUBECONFIG = $(shell pwd)/kubeconfig$(if $(filter dev,$(env)),-dev,).yaml

default: $(if $(filter dev,$(env)),k3d,boot cluster)

~/.ssh/id_ed25519:
	ssh-keygen -t ed25519 -P '' -f "$@"

boot: ~/.ssh/id_ed25519
	ansible-playbook \
		--inventory inventories/${env}.yml \
		boot.yml

cluster:
	ansible-playbook \
		--inventory inventories/${env}.yml \
		cluster.yml

# Destroy the cluster but keep the OS, see reset.yml
reset:
	ansible-playbook \
		--inventory inventories/${env}.yml \
		reset.yml

console:
	ansible-console \
		--inventory inventories/${env}.yml

k3d:
	k3d cluster start homelab-dev || k3d cluster create --config k3d-dev.yaml
	k3d kubeconfig get homelab-dev > $(KUBECONFIG)
