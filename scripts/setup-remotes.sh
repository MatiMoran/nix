#!/bin/sh
# After cloning this repo from any provider, run:
#   bash scripts/setup-remotes.sh
# It reconfigures `origin` so that fetch comes from GitHub (primary) and
# `git push` pushes to GitHub, plus GitLab as a second target when that
# remote is reachable. It also sets upstream tracking for every local
# branch that exists on origin.

set -euo pipefail

GITHUB_URL="git@github.com:MatiMoran/nix.git"
GITLAB_URL="git@gitlab.com:MatiMoran/nix.git"

if git remote get-url origin >/dev/null 2>&1; then
  git remote remove origin
fi

if git remote get-url gitlab >/dev/null 2>&1; then
  git remote remove gitlab
fi

git remote add origin "$GITHUB_URL"
git remote set-url --add --push origin "$GITHUB_URL"

# Add GitLab as a second push target only if the repo is reachable. This keeps
# pushes working while the GitLab mirror does not exist yet.
if GIT_SSH_COMMAND='ssh -o BatchMode=yes -o ConnectTimeout=5' git ls-remote "$GITLAB_URL" >/dev/null 2>&1; then
  git remote set-url --add --push origin "$GITLAB_URL"
  echo "GitLab reachable: pushes will go to GitHub and GitLab."
else
  echo "WARN: GitLab repo not reachable at $GITLAB_URL; pushing to GitHub only."
fi

# Removing origin wipes refs/remotes/origin/*; refetch so tracking refs exist.
git fetch origin --prune

# Set upstream tracking for every local branch that exists on origin.
for branch in $(git for-each-ref --format='%(refname:short)' refs/heads); do
  if git rev-parse --quiet --verify "refs/remotes/origin/$branch" >/dev/null; then
    git branch --set-upstream-to="origin/$branch" "$branch"
  else
    echo "WARN: branch '$branch' has no origin/$branch; leaving it untracked"
  fi
done

echo "Remotes configured:"
git remote -v
