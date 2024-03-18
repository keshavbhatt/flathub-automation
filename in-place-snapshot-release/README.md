# in-place-snapshot-release

This project contains `make` file with some targets to automatize release process for flathub repositories of my projects.

In place snapshot release means opening automated PR for project on flathub to produce a build with out any real change but trigger the build just so that the new build can use the latets snapshot of corresponding snap package and pick latest changes from there.

## How to use?

- Clone flahub git repositories you want to manage to root fo this project
- run `make REPO=com.ktechpit.torrhunt/ make_new_release_pr` to produce new release PR and open web browser with pre-populated github PR page.
- once done we can delete all branches other than master with `make REPO=com.ktechpit.torrhunt/ delete_branches_except_master`
- see make file for more interesting targets(usually we dont use them directly)
