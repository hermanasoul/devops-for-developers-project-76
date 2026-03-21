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
deploy-redmine: install-deps
	@echo "Deploying Redmine..."
	ansible-playbook -i inventory.ini redmine-deploy.yml --ask-vault-pass

.PHONY: edit-vault

edit-vault:
	@echo "Editing vault file..."
	ansible-vault edit group_vars/webservers/vault.yml

.PHONY: install-deps prepare deploy deploy-redmine monitor edit-vault

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
	ansible-playbook -i inventory.ini deploy.yml --ask-vault-pass

deploy-redmine: install-deps
	@echo "Deploying Redmine..."
	ansible-playbook -i inventory.ini redmine-deploy.yml --ask-vault-pass

monitor: install-deps
	@echo "Installing Datadog agent..."
	ansible-playbook -i inventory.ini monitoring.yml --ask-vault-pass

edit-vault:
	@echo "Editing vault file..."
	ansible-vault edit group_vars/webservers/vault.yml
	