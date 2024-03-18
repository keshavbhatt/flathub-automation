REPO :=
REPO_CLEAN := $(patsubst %/,%,$(REPO)) # remove trailing slash from REPO path
REPO_CLEAN_PATH := $(strip $(REPO_CLEAN)) # remove additional space introduce in slash cleanup
REPO_CLEAN_PATH := $(strip $(REPO_CLEAN_PATH))
CURRENT_BRANCH :=
NEW_PR_TITLE := "chore%3A%5Bsnapshot%5D%20new%20release%20"
NEW_PR_DESCRIPTION := "%60automatic%20in-place%20snapshot%20update%60"

debug_repo_path:
	@echo "REPO_CLEAN: $(REPO_CLEAN)last"
	@echo "REPO_CLEAN_PATH: $(REPO_CLEAN_PATH)last"
	@echo "REPO_CLEAN_PATH: $(strip $(REPO_CLEAN_PATH))last"

define git_remote_update
	cd $(REPO_CLEAN_PATH) && git remote update
endef

define git_pull
	cd $(REPO_CLEAN_PATH) && git pull --rebase
endef

define git_checkout
	cd $(REPO_CLEAN_PATH) && git checkout $(2)
	$(eval CURRENT_BRANCH := $(shell cd $(REPO_CLEAN_PATH) && git rev-parse --abbrev-ref HEAD))
endef

delete_branches_except_master:
	@echo "Deleting all branches except master..."
	@cd $(REPO_CLEAN_PATH) && git checkout master && \
	git branch | grep -v 'master' | xargs git branch -D
	@echo "All branches except master have been deleted."

fetch_remote:
	$(call git_remote_update, $(REPO_CLEAN_PATH))

pull_changes:
	$(call git_pull, $(REPO_CLEAN_PATH))

checkout_master_branch:
	$(call git_checkout, $(REPO_CLEAN_PATH), master)

checkout_feature_branch: checkout_master_branch pull_changes
	@cd $(REPO_CLEAN_PATH) && git pull && git checkout -b `openssl rand -hex 5`
	$(eval CURRENT_BRANCH := $(shell cd $(REPO_CLEAN_PATH) && git rev-parse --abbrev-ref HEAD))

modify_flatpak_manifest:
	$(eval CURRENT_BRANCH := $(shell cd $(REPO_CLEAN_PATH) && git rev-parse --abbrev-ref HEAD))
	@cd "$(REPO_CLEAN_PATH)" && \
        "$(CURDIR)/update.sh" "$(REPO_CLEAN_PATH).yaml"

commit_change:
	$(eval CURRENT_BRANCH := $(shell cd $(REPO_CLEAN_PATH) && git rev-parse --abbrev-ref HEAD))
	@cd "$(REPO_CLEAN_PATH)" && \
	git commit -a -m "chore: new release"

push_origin:
	$(eval CURRENT_BRANCH := $(shell cd $(REPO_CLEAN_PATH) && git rev-parse --abbrev-ref HEAD))
	@cd "$(REPO_CLEAN_PATH)" && \
	git push --set-upstream origin $(CURRENT_BRANCH)

open_pr:
	@xdg-open "https://github.com/flathub/$(REPO_CLEAN_PATH)/compare/$(CURRENT_BRANCH)?expand=1&title=$(NEW_PR_TITLE)&body=$(NEW_PR_DESCRIPTION)" &

make_new_release_pr: fetch_remote checkout_feature_branch modify_flatpak_manifest commit_change push_origin open_pr


print_current_branch:
	$(eval CURRENT_BRANCH := $(shell cd $(REPO_CLEAN_PATH) && git rev-parse --abbrev-ref HEAD))
	@echo $(CURRENT_BRANCH)

.PHONY: make_new_release_pr checkout_feature_branch checkout_master_branch fetch_remote print_current_branch delete_branches_except_master modify_flatpak_manifest
