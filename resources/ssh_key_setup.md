# Setting Up SSH Keys for GitHub

This guide explains how to set up SSH keys for multiple GitHub accounts.

## 1. Generate SSH Keys

Generate a separate SSH key for each GitHub account:

```bash
# For work account
ssh-keygen -t ed25519 -C "work-email@example.com" -f ~/.ssh/id_ed25519_work

# For personal account  
ssh-keygen -t ed25519 -C "personal-email@example.com" -f ~/.ssh/id_ed25519_personal
```

## 2. Add SSH Keys to SSH Agent

```bash
# Start SSH agent
eval "$(ssh-agent -s)"

# Add SSH keys to agent
ssh-add ~/.ssh/id_ed25519_work
ssh-add ~/.ssh/id_ed25519_personal
```

## 3. Configure SSH

Create or edit `~/.ssh/config` file:

```
# Default GitHub account (Work)
Host github.com
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
```

## 4. Add SSH Keys to GitHub Accounts

### Copy SSH public keys:

```bash
# For work account
cat ~/.ssh/id_ed25519_work.pub

# For personal account
cat ~/.ssh/id_ed25519_personal.pub
```

### Add to GitHub:

1. Log in to GitHub account
2. Go to Settings → SSH and GPG keys → New SSH key
3. Add a title (e.g., "Work MacBook" or "Personal MacBook")
4. Paste the SSH key
5. Click "Add SSH key"

## 5. Test SSH Connection

```bash
# Test connection to work account
ssh -T git@github.com

# Test connection to personal account  
ssh -T git@github-personal
```

You should see a message like: "Hi username! You've successfully authenticated..."

## 6. Using SSH with Different Accounts

### Cloning repositories:

```bash
# Clone work repository 
git clone git@github.com:organization/repo.git

# Clone personal repository
git clone git@github-personal:username/repo.git
```

### Changing remote URL for existing repositories:

```bash
# Change to work account
git remote set-url origin git@github.com:organization/repo.git

# Change to personal account
git remote set-url origin git@github-personal:username/repo.git