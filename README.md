# zsh-cwd-history

_Scopes your command history to the current working directory._

Idea from https://github.com/jimhester/per-directory-history


## Installation

### Manual

1. Clone this repository somewhere on your machine. This guide will assume `~/.zsh/zsh-cwd-history`.

    ```sh
    git clone git://github.com/ericfreese/zsh-cwd-history ~/.zsh/zsh-cwd-history
    ```

2. Add the following to your `.zshrc`:

    ```sh
    source ~/.zsh/zsh-cwd-history/zsh-cwd-history.zsh
    ```

3. Start a new terminal session.


### Oh My Zsh

1. Clone this repository into `$ZSH_CUSTOM/plugins` (by default `~/.oh-my-zsh/custom/plugins`)

    ```sh
    git clone git://github.com/ericfreese/zsh-cwd-history $ZSH_CUSTOM/plugins/zsh-cwd-history
    ```

2. Add the plugin to the list of plugins for Oh My Zsh to load:

    ```sh
    plugins=(zsh-cwd-history)
    ```

3. Start a new terminal session.


## Usage

As you change directories, the zsh history list will be updated to show only the commands that were executed in that directory.

History will be saved and read according to the [standard ZSH history options](http://zsh.sourceforge.net/Doc/Release/Options.html#History), with the exception that cwd history files (stored under `$ZSH_CWD_HISTORY_DIR`) will be written to when switching directories.

This plugin provides a zle widget to toggle between cwd history and global history but does not bind any keys by default. To enable the widget, see the section on [configuring key bindings](#key-bindings) below.

## Configuration

You may want to override the default global config variables after sourcing the plugin. Default values of these variables can be found [here](src/config.zsh).

**Note:** If you are using Oh My Zsh, you can put this configuration in a file in the `$ZSH_CUSTOM` directory. See their comments on [overriding internals](https://github.com/robbyrussell/oh-my-zsh/wiki/Customization#overriding-internals).


### History Directory

You can configure the location where history data for each directory will be saved by setting the `$ZSH_CWD_HISTORY_DIR` global variable after sourcing this plugin.

For example:

```shell
ZSH_CWD_HISTORY_DIR=~/my/special/history/dir
```


### Key Bindings

This plugin provides a `cwd-history-toggle` widget that you can use with `bindkey` to toggle cwd history on/off This will switch between whatever HISTFILE was active before this plugin was initialized.

For example, this would bind <kbd>ctrl</kbd> + <kbd>B</kbd> to toggle cwd history.

```sh
bindkey '^B' cwd-history-toggle
```


### Messages

You can configure how loud this plugin is about changing history files by setting the `$ZSH_CWD_HISTORY_SHOW_TOGGLE_MSG` and `$ZSH_CWD_HISTORY_SHOW_CHPWD_MSG` global variables.

For example, to turn off all messages:

```shell
ZSH_CWD_HISTORY_SHOW_TOGGLE_MSG=false
ZSH_CWD_HISTORY_SHOW_CHPWD_MSG=false
```


## Troubleshooting

If you have a problem, please search through [the list of issues on GitHub](https://github.com/ericfreese/zsh-cwd-history/issues) to see if someone else has already reported it.


### Reporting an Issue

Before reporting an issue, please try temporarily disabling sections of your configuration and other plugins that may be conflicting with this plugin to isolate the problem.

When reporting an issue, please include:

- The smallest, simplest `.zshrc` configuration that will reproduce the problem.
- The version of zsh you're using (`zsh --version`)
- Which operating system you're running


## Uninstallation

1. Remove the code referencing this plugin from `~/.zshrc`.

2. Remove the git repository from your hard drive

    ```sh
    rm -rf ~/.zsh/zsh-cwd-history # Or wherever you installed
    ```


## Development

### Build Process

Edit the source files in `src/`. Run `make` to build `zsh-cwd-history.zsh` from those source files.


### Pull Requests

Pull requests are welcome! If you send a pull request, please:

- Match the existing coding conventions.
- Include helpful comments to keep the barrier-to-entry low for people new to the project.


## License

This project is licensed under [MIT license](http://opensource.org/licenses/MIT).
For the full text of the license, see the [LICENSE](LICENSE) file.
