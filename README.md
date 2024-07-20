# `chk-upstream`
`chk-upstream` retrieves a git repository version and compares it against a pacman package version

## Prerequestits
`chk-upstream` uses the [github cli tool](https://github.com/cli/cli) to read the githib api.
It requires a github user account to work!

Once `gh` is installed [authenticate](https://cli.github.com/manual/gh_auth): call `gh auth login` and follow the prompts or use the one liner `gh auth login --with-token <<<"github_token"`. A token can be created in your github user account under *settings / Developer Settings / Personal Access Tokes*.

## Usage
```bash
 Usage: chk-upstream -g git_repository_name -p package_name
    or: chk-upstream --git git_repository_name --pacman package_name
    or: chk-upstream -h
    or: chk-upstream --help
```

## Change-log
### Version 1.2
 * added command line parameter '-s' & '--string': the string will be compared against the pacman package version

### Version 1.1
 * renamed to chk-upstream (formally chk_pkg_upstream)
 * added command line parameter `--git` and `--pacman`

### Version 1.0
All basic functions are implemented:
 * reads git repository and pacman package name from arguments
 * gets git upstream version
 * compares version and display result
