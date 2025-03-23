#!/bin/sh
_p_w_d=$(pwd)

echo > /etc/motd
sed -i '1,/robbyrussell/{s/robbyrussell/afowler/}' ~/.zshrc
echo "DISABLE_AUTO_UPDATE=true" >> /root/.zshrc
echo 'source ~/.alias' >> ~/.zshrc
echo "zstyle ':omz:update' mode disabled" >> ~/.zshrc

usermod --shell /bin/zsh root

cd $_p_w_d && rm -f $0