BRANCH_NAME := feature/new-raw-data
SRC_DIR := /code/app/src

.SILENT:

git-config:
	@echo "## Configuring  repository"
	git config --global --add safe.directory /root/Models/omc
	
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
	gcloud config set project ferrous-amphora-398306
	mkdir data/ardilla/raw

update-data:
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
