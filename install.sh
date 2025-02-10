sudo pacman -S --needed --noconfirm - <./arch-official-packages.txt

mv ./exclude-config.sh ./config.sh
sudo cp -R ./to-doc.sh $HOME/.shell_config_features.d/to-doc.sh

sudo chmod +x $HOME/.shell_config_features.d/to-doc.sh
