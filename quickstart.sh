#/bin/bash

xargs brew install < brew-packages.txt

brew install --cask font-jetbrains-mono-nerd-font
brew install --cask font-symbols-only-nerd-font
brew install --cask wezterm
brew install --cask spotify
brew install --cask obsidian
brew install --cask visual-studio-code
brew install --cask fantastical
brew install --cask brave-browser
brew install --cask whatsapp
brew install --cask vlc
brew install --cask screen-studio

stow .

# Make bat adopt the new theme
bat cache --build

# asdf python
asdf plugin-add python
asdf install python latest
asdf global python latest

# asdf nodejs
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf install nodejs latest
asdf global nodejs latest

# asdf Elixir (Erlang is a prerequisite)
asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git
asdf install erlang latest
asdf global erlang latest

asdf plugin add elixir https://github.com/asdf-vm/asdf-elixir.git
asdf install elixir latest
asdf global elixir latest

# asdf lua
asdf plugin-add lua https://github.com/Stratus3D/asdf-lua.git
asdf install lua latest
asdf global lua latest


