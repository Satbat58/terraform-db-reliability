.PHONY: help

help:
	@echo "Available Commands"
	@echo "------------------------------"
	@echo "make init"
	@echo "make fmt"
	@echo "make validate"
	@echo "make plan"
	@echo "make db-up"
	@echo "make db-down"
	@echo "make backup"
	@echo "make restore"
	@echo "make verify"

##########################################
# Terraform
##########################################

init:
	cd infra/envs/dev && terraform init

fmt:
	cd infra/envs/dev && terraform fmt -recursive

validate:
	cd infra/envs/dev && terraform validate

plan:
	cd infra/envs/dev && terraform plan

##########################################
# Docker
##########################################

db-up:
	docker compose up -d

db-down:
	docker compose down

##########################################
# Backup
##########################################

backup:
	chmod +x scripts/backup.sh
	./scripts/backup.sh

##########################################
# Restore
##########################################

restore:
	chmod +x scripts/restore.sh
	./scripts/restore.sh

##########################################
# Verification
##########################################

verify:
	chmod +x scripts/verify.sh
	./scripts/verify.sh