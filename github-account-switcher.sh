#!/bin/bash

# GitHub Account Switcher
# A tool to easily manage multiple GitHub accounts on the same machine

# Define your GitHub accounts - MODIFY THESE WITH YOUR ACTUAL ACCOUNTS
WORK_USERNAME="jevesh-code"
WORK_EMAIL="jevesh@thesilverlabs.com"
WORK_SSH_KEY="~/.ssh/id_ed25519"
WORK_SSH_HOST="github-work"

PERSONAL_USERNAME="jp8042"
PERSONAL_EMAIL="jevesh8042@gmail.com"
PERSONAL_SSH_KEY="~/.ssh/id_ed25519_personal"
PERSONAL_SSH_HOST="github-personal"

# Function to display current GitHub account
github_current() {
  echo "Current GitHub account:"
  echo "  User: $(git config --global user.name)"
  echo "  Email: $(git config --global user.email)"
}

# Function to switch to work GitHub account
github_work() {
  git config --global user.name "$WORK_USERNAME"
  git config --global user.email "$WORK_EMAIL"
  echo "Switched to work GitHub account:"
  github_current
}

# Function to switch to personal GitHub account
github_personal() {
  git config --global user.name "$PERSONAL_USERNAME"
  git config --global user.email "$PERSONAL_EMAIL"
  echo "Switched to personal GitHub account:"
  github_current
}

# Function to clone a repository with the work account using SSH
github_clone_work() {
  if [ -z "$1" ]; then
    echo "Usage: github_clone_work <repository-name> [directory]"
    echo "Example: github_clone_work organization/repo-name"
    return 1
  fi
  
  local repo_name="$1"
  local dir_name="${2:-${repo_name##*/}}"
  
  # Convert to SSH URL if needed
  if [[ "$repo_name" == https://* ]]; then
    # Extract the path part from the HTTPS URL
    repo_name=${repo_name#https://github.com/}
    repo_name=${repo_name%.git}
  fi
  
  git clone "git@${WORK_SSH_HOST}:${repo_name}.git" "$dir_name"
  cd "$dir_name" || return
  git config user.name "$WORK_USERNAME"
  git config user.email "$WORK_EMAIL"
  echo "Repository cloned with work GitHub account configuration."
}

# Function to clone a repository with the personal account using SSH
github_clone_personal() {
  if [ -z "$1" ]; then
    echo "Usage: github_clone_personal <repository-name> [directory]"
    echo "Example: github_clone_personal username/repo-name"
    return 1
  fi
  
  local repo_name="$1"
  local dir_name="${2:-${repo_name##*/}}"
  
  # Convert to SSH URL if needed
  if [[ "$repo_name" == https://* ]]; then
    # Extract the path part from the HTTPS URL
    repo_name=${repo_name#https://github.com/}
    repo_name=${repo_name%.git}
  fi
  
  git clone "git@${PERSONAL_SSH_HOST}:${repo_name}.git" "$dir_name"
  cd "$dir_name" || return
  git config user.name "$PERSONAL_USERNAME"
  git config user.email "$PERSONAL_EMAIL"
  echo "Repository cloned with personal GitHub account configuration."
}

# Function to configure the current repository to use work account
github_set_work() {
  git config user.name "$WORK_USERNAME"
  git config user.email "$WORK_EMAIL"
  echo "Repository configured to use work GitHub account."
}

# Function to configure the current repository to use personal account
github_set_personal() {
  git config user.name "$PERSONAL_USERNAME"
  git config user.email "$PERSONAL_EMAIL"
  echo "Repository configured to use personal GitHub account."
}

# Function to convert repository remote to use work SSH
github_remote_work() {
  local remote="${1:-origin}"
  local current_url=$(git config --get "remote.$remote.url")
  
  if [[ -z "$current_url" ]]; then
    echo "Remote '$remote' not found."
    return 1
  fi
  
  # Extract the repository path from the URL
  local repo_path
  if [[ "$current_url" == https://* ]]; then
    repo_path=${current_url#https://github.com/}
    repo_path=${repo_path%.git}
  elif [[ "$current_url" == git@* ]]; then
    repo_path=${current_url#git@*:}
    repo_path=${repo_path%.git}
  else
    echo "Unsupported URL format: $current_url"
    return 1
  fi
  
  # Set the new URL
  local new_url="git@${WORK_SSH_HOST}:${repo_path}.git"
  git remote set-url "$remote" "$new_url"
  echo "Remote '$remote' updated to: $new_url"
}

# Function to convert repository remote to use personal SSH
github_remote_personal() {
  local remote="${1:-origin}"
  local current_url=$(git config --get "remote.$remote.url")
  
  if [[ -z "$current_url" ]]; then
    echo "Remote '$remote' not found."
    return 1
  fi
  
  # Extract the repository path from the URL
  local repo_path
  if [[ "$current_url" == https://* ]]; then
    repo_path=${current_url#https://github.com/}
    repo_path=${repo_path%.git}
  elif [[ "$current_url" == git@* ]]; then
    repo_path=${current_url#git@*:}
    repo_path=${repo_path%.git}
  else
    echo "Unsupported URL format: $current_url"
    return 1
  fi
  
  # Set the new URL
  local new_url="git@${PERSONAL_SSH_HOST}:${repo_path}.git"
  git remote set-url "$remote" "$new_url"
  echo "Remote '$remote' updated to: $new_url"
}

# Function to commit changes with work account
github_commit_work() {
  if [ -z "$1" ]; then
    echo "Usage: github_commit_work <commit-message>"
    return 1
  fi
  
  local temp_name=$(git config user.name)
  local temp_email=$(git config user.email)
  
  git config user.name "$WORK_USERNAME"
  git config user.email "$WORK_EMAIL"
  
  git commit -m "$1"
  
  # Restore previous config
  git config user.name "$temp_name"
  git config user.email "$temp_email"
  
  echo "Committed with work GitHub account."
}

# Function to commit changes with personal account
github_commit_personal() {
  if [ -z "$1" ]; then
    echo "Usage: github_commit_personal <commit-message>"
    return 1
  fi
  
  local temp_name=$(git config user.name)
  local temp_email=$(git config user.email)
  
  git config user.name "$PERSONAL_USERNAME"
  git config user.email "$PERSONAL_EMAIL"
  
  git commit -m "$1"
  
  # Restore previous config
  git config user.name "$temp_name"
  git config user.email "$temp_email"
  
  echo "Committed with personal GitHub account."
}

# Function to print SSH keys for adding to GitHub
github_show_ssh_keys() {
  echo "=== Work GitHub SSH Key ==="
  echo "Add this public key to your work GitHub account ($WORK_USERNAME):"
  echo "Path: ${WORK_SSH_KEY}.pub"
  
  echo -e "\n=== Personal GitHub SSH Key ==="
  echo "Add this public key to your personal GitHub account ($PERSONAL_USERNAME):"
  echo "Path: ${PERSONAL_SSH_KEY}.pub"
}

# Display usage information
github_help() {
  echo "GitHub Account Manager Commands:"
  echo
  echo "Account Switching:"
  echo "  github_current         - Display current GitHub account"
  echo "  github_work            - Switch global config to work account"
  echo "  github_personal        - Switch global config to personal account"
  echo
  echo "Repository Operations:"
  echo "  github_clone_work <repo> [dir]      - Clone a repository with work account"
  echo "  github_clone_personal <repo> [dir]  - Clone a repository with personal account"
  echo "  github_set_work                     - Configure current repository to use work account"
  echo "  github_set_personal                 - Configure current repository to use personal account"
  echo "  github_remote_work [remote]         - Convert remote to use work SSH (default: origin)"
  echo "  github_remote_personal [remote]     - Convert remote to use personal SSH (default: origin)"
  echo
  echo "Commit Operations:"
  echo "  github_commit_work <msg>     - Commit changes with work account"
  echo "  github_commit_personal <msg> - Commit changes with personal account"
  echo
  echo "SSH Key Management:"
  echo "  github_show_ssh_keys         - Show SSH public keys for adding to GitHub accounts"
  echo
  echo "For the clone commands, you can use either the full repository name or URL:"
  echo "  github_clone_work organization/repository-name"
  echo "  github_clone_personal personal-username/repository-name"
}

# Run github_current to show the current account when the script is sourced
github_current
echo -e "\nRun 'github_help' to see all available commands."
echo "Important: Make sure to update the account variables at the top of this script with your actual GitHub accounts!"