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

```sh
asdf plugin-add python
asdf install python latest
asdf global python latest
```

##### nodejs

```sh
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf install nodejs latest
asdf global nodejs latest
```

##### Elixir

- see [this](https://gigalixir.com/blog/a-beginners-guide-to-installing-elixir-with-asdf/)

##### Lua

```sh
asdf plugin-add lua https://github.com/Stratus3D/asdf-lua.git
asdf install lua latest
asdf global lua latest
```

#### Ref:

- [Dreams of Autonomy](https://www.youtube.com/watch?v=y6XCebnB9gs)
