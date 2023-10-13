BRANCH_NAME := feature/new-raw-data

.SILENT:

branch:
	@echo "## Creating branch in current repository"
	git checkout -b $(BRANCH_NAME) develop

login:
	@echo "Please login to your account"

push-video:
	@echo "## Pushing data to bucket with DVC"
#	dvc add data/
	dvc push -r storage

push-branch:
	@echo "## Pushing branch to git repository"
	git add .
	git commit -m "new videos added in data/raw folder"
	git push -u origin $(BRANCH_NAME)


