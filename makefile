BRANCH_NAME := feature/new-raw-data
SRC_DIR := /code/app/src
PROJECT := ferrous-amphora-398306

.SILENT:

git-config:
	@echo "## Configuring  repository"
	git config --global --add safe.directory /root/Models/omc
	git config user.name = "from Docker container"
	git pull
	git branch -r | grep -v 'main'| while read remote; do git branch -f "$${remote#origin/}" "$$remote";done
	
branch: dev
	@echo "## Creating branch in current repository"
	git branch $(BRANCH_NAME)
	git switch $(BRANCH_NAME)
	
dev: 
	git branch -f develop origin/develop
	git switch develop

login:
	@echo "Please login to your account"
	gcloud auth login
	gcloud auth application-default login
	gcloud config set project $(PROJECT)
	mkdir -p data/ardilla/raw

pull-data:
	@echo "## Downloading data from bucket with DVC"
	. $(SRC_DIR)/.venv/bin/activate \
	&& dvc pull

push-video:
	@echo "## Pushing data to bucket with DVC"
	. $(SRC_DIR)/.venv/bin/activate \
	&& dvc add data/ \
	&& dvc push -r storage

push-branch:
	@echo "## Pushing branch to git repository"
	git add .
	git commit -m "new videos added in data/raw folder"
	git push -u origin $(BRANCH_NAME)
	
	
test:
	@echo "## testing dvc"
	. $(SRC_DIR)/.venv/bin/activate \
	&& dvc doctor
