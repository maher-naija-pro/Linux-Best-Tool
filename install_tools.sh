###############################################################################
# check os versio
os=$(cat /etc/os-release | grep PRETTY_NAME |  cut -d'"' -f2)

known_versions=("Rocky Linux 9.2 (Blue Onyx)" "CentOS Linux 7 (Core)" "Rocky Linux 9.1 (Blue Onyx)", "Rocky Linux 9.3 (Blue Onyx)" )

found=false

for known_version in "${known_versions[@]}"; do
        if [ "$os" = "$known_version" ]; then
            found=true
            break
        fi
done

if $found; then
        echo "Current OS version ($os) is in the list of supported OS."
    else
        echo "Current OS version ($os) is not in the list of not supported OS."
        exit 1
fi

export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_COLLATE=C
export LC_CTYPE=en_US.UTF-8
####################################################################################""
if [ "$os" == "CentOS Linux 7 (Core)" ]; then
echo "Install epel releases"
yum install -y -q  epel-release
yum update -y -q 
fi

my_list="bind-utils
curl
dmidecode
fio
iotop
lsof
mlocate
net-tools
nmap
nc
sysstat
tcpdump
telnet
traceroute
tree
unzip
vim-enhanced
wget
zsh
bc
tmux 
git
strace
python3.x86_64
python3-pip.noarch
epel-release.noarch
xclip
socat
btop
tltr
lsscsi"


IFS=$'\n' read -rd '' -a list_array <<< "$my_list"

echo "Install basic package tools : it can take some minites please wait ..."
for item in "${list_array[@]}"; do
    sudo yum -y -q install $item 
done

echo "Configure git"
#configure
git config --global credential.helper store
git config --global user.email "maher.naija@gmail.com"
git config --global user.name "maher.naija"


#install oh my zsh
echo "Install Oh-myzsh"
user=$(whoami)

rm -rf /home/"$user"/.oh-my-zsh/custom/plugins/zsh*

ZSH="$HOME/.oh-my-zsh" sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)   --skip-chsh  --unattended"


echo "Install zsh-autosuggestions"

ZSH_CUSTOM=/home/"$user"/.oh-my-zsh/custom && git clone --quiet https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions

echo "Install zsh-syntax-highlighting"


ZSH_CUSTOM=/home/"$user"/.oh-my-zsh/custom && git clone --quiet https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

echo "Install zsh-history-substring-search"

ZSH_CUSTOM=/home/"$user"/.oh-my-zsh/custom && git clone --quiet https://github.com/zsh-users/zsh-history-substring-search $ZSH_CUSTOM/plugins/zsh-history-substring-search


# make zsh default shell
echo "set zsh for user"
sudo usermod --shell /usr/bin/zsh  outscale 


#install theme 
ZSH_CUSTOM=/home/"$user"/.oh-my-zsh/custom && git clone https://github.com/romkatv/powerlevel10k.git  /home/"$user"/.oh-my-zsh/themes/powerlevel10k 

curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim 


sh -c -v "$(curl -s -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/maher-naija-pro/All-my-configs/main/conf.sh )"

if [ $1 == "admin" ]
then 
# install aws cli

  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.z
  ip" -o "awscliv2.zip"
  unzip awscliv2.zip
  sudo ./aws/install &
  rm -rf  awscliv2.zip

  sh -c -v "$(curl -s -H 'Cache-Control: no-cache, no-store'  https://raw.githubusercontent.com/maher-naija-pro/All-my-configs/main/admin_conf.sh )"

fi 

echo "###########################################################"
echo "###########################################################"
echo " ALL INSTALL SUCCESSFUL"
echo " Reconnect to your session "
echo "###########################################################"
echo "###########################################################"
