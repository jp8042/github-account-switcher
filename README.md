# GitHub Account Switcher

A simple bash utility to manage multiple GitHub accounts on a single machine. This tool makes it easy to switch between different GitHub accounts, clone repositories with the correct account, and make commits under different identities.

## Features

- Switch between multiple GitHub accounts with a single command
- Clone repositories using the correct account credentials
- Make commits using a specific account, regardless of global Git settings
- Convert repository remotes to use the appropriate SSH configuration
- Compatible with both HTTPS and SSH repository URLs

## Installation

1. Clone this repository:
```bash
git clone https://github.com/username/github-account-switcher.git
```

2. Edit the script to configure your GitHub accounts:
```bash
cd github-account-switcher
nano github-account-switcher.sh
```

3. Update the account variables at the top of the script:
```bash
WORK_USERNAME="your-work-username"
WORK_EMAIL="your-work-email@example.com"
WORK_SSH_KEY="~/.ssh/id_ed25519_work"
WORK_SSH_HOST="github-work"

PERSONAL_USERNAME="your-personal-username"
PERSONAL_EMAIL="your-personal-email@example.com"
PERSONAL_SSH_KEY="~/.ssh/id_ed25519_personal"
PERSONAL_SSH_HOST="github-personal"
```

4. Add the script to your shell configuration:
```bash
echo "source $(pwd)/github-account-switcher.sh" >> ~/.bashrc
# or for zsh
echo "source $(pwd)/github-account-switcher.sh" >> ~/.zshrc
```

5. Reload your shell or source the configuration file:
```bash
source ~/.bashrc
# or for zsh
source ~/.zshrc
```

## SSH Configuration

For optimal usage with SSH, create separate SSH keys for each GitHub account and configure them in your SSH config file:

1. Generate SSH keys for each account:
```bash
ssh-keygen -t ed25519 -C "work-email@example.com" -f ~/.ssh/id_ed25519_work
ssh-keygen -t ed25519 -C "personal-email@example.com" -f ~/.ssh/id_ed25519_personal
```

2. Configure SSH to use different hosts for GitHub:
```bash
cat >> ~/.ssh/config << 'EOF'
# Default GitHub account (Work)
Host github-work
   HostName github.com
   User git
   IdentityFile ~/.ssh/id_ed25519_work
   IdentitiesOnly yes

# Personal GitHub account
Host github-personal
   HostName github.com
   User git
   IdentityFile ~/.ssh/id_ed25519_personal
   IdentitiesOnly yes
EOF
```

3. Add your SSH keys to the corresponding GitHub accounts.

## Usage

### Switching Between Accounts

```bash
# Switch to work account globally
github_work

# Switch to personal account globally
github_personal

# Check which account is currently active
github_current
```

### Cloning Repositories

```bash
# Clone a work repository (format: organization/repo-name)
github_clone_work organization/repo-name

# Clone a personal repository (format: username/repo-name)
github_clone_personal personal-username/repo-name custom-dir
```

### Repository-Specific Configuration

```bash
# Configure the current repository to use work account
github_set_work

# Configure the current repository to use personal account
github_set_personal

# Convert remote URL to use work SSH
github_remote_work

# Convert remote URL to use personal SSH
github_remote_personal
```

### Committing with Specific Account

```bash
# Add files to staging
git add .

# Commit with work account
github_commit_work "Fix bug in authentication"

# Commit with personal account
github_commit_personal "Add new feature to homepage"
```

## How It Works

The script provides commands that automatically configure Git to use the appropriate email and username when interacting with different GitHub accounts. When combined with SSH host aliases, it creates a seamless workflow for managing multiple GitHub accounts.

## License

MIT