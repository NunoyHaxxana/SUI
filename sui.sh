#!/bin/bash
echo "========================================================================================"
echo -e "\033[0;35m"
echo "    ___               _          _  _             _    _                   ___   _      ___ ";
echo "   / __\ ___   _ __  | |_  _ __ (_)| |__   _   _ | |_ (_)  ___   _ __     /   \ /_\    /___\";
echo "  / /   / _ \ | '_ \ | __|| '__|| || '_ \ | | | || __|| | / _ \ | '_ \   / /\ ///_\\  //  //";
echo " / /___| (_) || | | || |_ | |   | || |_) || |_| || |_ | || (_) || | | | / /_///  _  \/ \_// ";
echo " \____/ \___/ |_| |_| \__||_|   |_||_.__/  \__,_| \__||_| \___/ |_| |_|/___,' \_/ \_/\___/  ";

echo -e "\e[0m"
echo "========================================================================================"                                                                                          
sleep 1


echo -e "\e[1m\e[32m1. Updating packages \e[0m" && sleep 1
sudo apt update && sudo apt upgrade -y


echo -e "\e[1m\e[32m2. Install dependencies \e[0m" && sleep 1
sudo apt-get update && DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get install -y --no-install-recommends tzdata git ca-certificates curl build-essential libssl-dev pkg-config libclang-dev cmake jq


echo -e "\e[1m\e[32m3. Install Rust \e[0m" && sleep 1
sudo curl https://sh.rustup.rs -sSf | sh -s -- -y
source $HOME/.cargo/env

echo -e "\e[1m\e[32m4. Install Sui \e[0m" && sleep 1
sudo mkdir -p /var/sui/db
cd $HOME
git clone https://github.com/MystenLabs/sui.git
cd sui
git remote add upstream https://github.com/MystenLabs/sui
git fetch upstream
git checkout --track upstream/devnet
wget -O /var/sui/genesis.blob https://github.com/MystenLabs/sui-genesis/raw/main/devnet/genesis.blob
sudo cp crates/sui-config/data/fullnode-template.yaml /var/sui/fullnode.yaml
cargo build --release -p sui-node
sudo mv ~/sui/target/release/sui-node /usr/local/bin/
sudo cp /var/sui/fullnode.yaml /var/sui/fullnode.yaml.bak
sudo sed -i 's/suidb/\/var\/sui\/db/'  /var/sui/fullnode.yaml
sudo sed -i 's/127.0.0.1/0.0.0.0/'  /var/sui/fullnode.yaml
sudo sed -i 's/genesis.blob/\/var\/sui\/genesis.blob/' /var/sui/fullnode.yaml


echo -e "\e[1m\e[32m5. Make Sui Service \e[0m" && sleep 1
echo "[Unit]
Description=Sui Node
After=network.target

[Service]
User=$USER
Type=simple
ExecStart=/usr/local/bin/sui-node --config-path /var/sui/fullnode.yaml
Restart=on-failure
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target" > $HOME/suid.service
mv $HOME/suid.service /etc/systemd/system/

sudo tee <<EOF >/dev/null /etc/systemd/journald.conf
Storage=persistent
EOF

sudo systemctl restart systemd-journald
sudo systemctl daemon-reload
sudo systemctl enable suid
sudo systemctl restart suid



echo "==================================================="
echo -e '\e[32mCheck your sui status\e[39m' && sleep 1
if [[ `service suid status | grep active` =~ "running" ]]; then
  echo -e "Your Sui node \e[32minstalled and running\e[39m!"
else
  echo -e "Your Sui node \e[31mwas not installed correctly\e[39m, Please reinstall."
fi

echo -e "\e[1m\e[32m6. Usefull commands \e[0m" && sleep 1
echo -e "Check your node logs: \e[journalctl -fu suid -o cat\e[39m\n\n"
echo -e "Check your node status: \e[sudo service suid status\e[39m\n\n"
echo -e "Restart your node: \e[sudo systemctl restart suid\e[39m\n\n"
echo -e "Stop your node: \e[sudo systemctl stop suid\e[39m\n\n"
echo -e "Start your node: \e[sudo systemctl start suid\e[39m\n\n"
