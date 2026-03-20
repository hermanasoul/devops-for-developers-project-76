.PHONY: install-deps prepare deploy

install-deps:
	@echo "Installing Ansible if not present..."
	which ansible || (sudo apt update && sudo apt install -y ansible)
	@echo "Installing Ansible Galaxy roles and collections..."
	ansible-galaxy install -r requirements.yml
	ansible-galaxy collection install -r requirements.yml

prepare: install-deps
	@echo "Running playbook to configure servers..."
	ansible-playbook -i inventory.ini playbook.yml

deploy: install-deps
	@echo "Deploying application..."
	ansible-playbook -i inventory.ini deploy.yml