### Managed by Stow:

- On updating the dotfiles, run:

```sh
 stow .
```

#### TODO:

- [ ] setup neovim
- [ ] add shell script for a fresh installation

##### Notes on fresh installations:

- add all the deps with `brew`, i.e.:

  - [ ] stow
  - [ ] starship
  - [ ] eza
  - [ ] bat
  - [ ] wezterm (requires --cask flag)
  - [ ] zsh-autosuggestions
  - [ ] zsh-syntax-highlighting
  - [ ] fzf
  - [ ] zoxide
  - [ ] brew install --cask font-jetbrains-mono-nerd-font
  - [ ] asdf
    - [ ] add python, nodejs and elixir with asdf (see notes below on asdf)

  - These could be added to a txt file, and run with:
  ```sh
  xargs brew install < apps.txt
  ```

- Run `bat cache --build` to refresh bat's cache.

#### asdf

##### python

###### install plugin

```sh
asdf plugin-add python
```

###### install a version

```sh
asdf install python latest
```

###### install a version

```sh
asdf global python latest
```

##### nodejs

###### install plugin

```sh
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
```

###### install a version

```sh
asdf install nodejs latest
```

###### set a version

```sh
asdf global nodejs latest
```

#### Ref:

- [Dreams of Autonomy](https://www.youtube.com/watch?v=y6XCebnB9gs)
