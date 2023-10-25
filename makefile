BRANCH_NAME := feature/new-raw-data
SRC_DIR := /code/app/src
PROJECT := ferrous-amphora-398306

.SILENT:

git-config:
	@echo "## Configuring  repository"
	git config --global --add safe.directory /root/Models/omc
	git pull
	git branch -r | grep -v 'main'| while read remote; do git branch -f "$${remote#origin/}" "$$remote";done
	
branch:
	@echo "## Creating branch in current repository"
	git switch develop
	git branch $(BRANCH_NAME)
	git switch $(BRANCH_NAME)
	
login:
	@echo "Please login to your account"
	gcloud auth login
	gcloud auth application-default login
	gcloud config set project $(PROJECT)


pull-data:
	@echo "## Downloading data from bucket with DVC"
	. $(SRC_DIR)/.venv/bin/activate \
	&& dvc pull

push-video:
	@echo "## Pushing data to bucket with DVC"
	. $(SRC_DIR)/.venv/bin/activate \
	&& dvc add data/ \
	&& dvc push -r storage

push-branch: # exec : make push-branch mail=yourmail@conceivable.life
	@echo "## Pushing branch to git repository"
	git config --global user.email = "test@test" 
	git add . | if read line; then git commit -m "new videos added in data/raw folder and uploaded to bucket with DVC";else echo  "\t no commit added due to there are no changes";fi
	git push -u origin $(BRANCH_NAME)
	
test:
	@echo "## testing dvc"
	. $(SRC_DIR)/.venv/bin/activate \
	&& dvc status
