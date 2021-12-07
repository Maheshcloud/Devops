Git:
### 1) Clone the repository and fetch only a single branch.

```sh
git clone --branch <branchname> <remote-repo-url>

git clone --branch <branchname> --single-branch <remote-repo-url>
```

### 2) Gitpull vs GitFetch vs GitRebase:
You can use git fetch to know the changes done in the remote repo/branch since your last pull. This is useful to allow for checking before doing an actual pull, which could change files in your current branch and working copy 

```sh
Git Fetch: Remote Repository --> Local Repository
```

A git pull is what you would do to bring a local branch up-to-date with its remote version, while also updating your other remote-tracking branches.

Git Pull: Remote Repository --> Local Repository(git fetch) -- > Working Copy(git merge) 

Rebasing is an alternative to merging. Instead of creating a new commit that combines the two branches, it moves the commits of one of the branches on top of the other.

You can pull using rebase instead of merge (git pull --rebase). The local changes you made will be rebased on top of the remote changes, instead of being merged with the remote changes.


### 3) To clone only last commit:

Use git clone with the --depth option set to 1 to create a shallow clone with a history truncated to the latest commit.

For example:
```sh
git clone --depth 1 https://github.com/user/repo.git
```

### 4) To get the clones URL from local:
```sh
git config --get remote.origin.url
```

### 5) .git folder contents: 
The .git folder contains all the information that is necessary for your project in version control and all the information about commits, remote repository address, etc. All of them are present in this folder. It also contains a log that stores your commit history so that you can roll back to history.

To untrack a single file, ie stop tracking the file but not delete it from the system use:
```sh
git rm --cached filename
```

### 6) What is sub module in git:
A git submodule is a record within a host git repository that points to a specific commit in another external repository. Submodules are very static and only track specific commits. When adding a submodule to a repository a new .gitmodules file will be created. 


### 7) How to untrack/delete specific file from staging: 
If you need to remove a single file from the staging area, use
```sh
git reset HEAD -- <file>
```
If you need to remove a whole directory (folder) from the staging area, use
```sh
git reset HEAD -- <directoryName>

(Or)
git rm --cached FILE
```

### 8) Git stash:
git stash temporarily shelves (or stashes) changes you've made to your working copy so you can work on something else, and then come back and re-apply them later on. 

The git stash command takes your uncommitted changes (both staged and unstaged), saves them away for later use, and then reverts them from your working copy. 

You can reapply previously stashed changes with git stash pop
Alternatively, you can reapply the changes to your working copy and keep them in your stash with git stash apply
If you decide you no longer need a particular stash, you can delete it with git stash drop Or you can delete all of your stashes with git stash clear

### Commands: 
git stash

git stash pop

git stash apply

git stash list

git stash save "message"  //to save stash with a message

git stash drop  //to delete a particular stash

git stash clear //you can delete all of your stashes

### 9) How to get the clone link if the repo name is changed?
Go to the folder in which name is changed
```sh
Type "git remote -v"
```

### 10) How to get only master branch and last commit
  ```sh
git clone -b master --single-branch --depth 1 gitURL
```
### 11) To check the commings of the Project:
  ```sh
git log --oneline
```
### 12) How to uncommit/unsave the file from staging?Or to move a file from staging to local
  ```sh
git rm --cached filename
```


### git reset vs git revert:

Git reset is a complex command, and it is used to undo the changes.

The purpose of git hard reset is to move the HEAD to the specified commit. It will remove all the commits with happened after the specified commit. This command will change the commit history and point to the specified commit.

In Git, the revert command is used to perform a revert operation, i.e., to revert some changes. It is similar to the reset command, but the only difference here is that you perform a new commit to go back to a particular commit. In short, it is fair to say that the git revert command is a commit.

In Git, rebase is the way of moving or combining commits of one branch over another branch. 


- To get all the branches :
```sh
git branch -r | grep -v '\->' | while read remote; do git branch --track "${remote#origin/}" "$remote"; done

git pull --all
```
