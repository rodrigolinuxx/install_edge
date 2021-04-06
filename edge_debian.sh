echo
echo $'--------------\nMicrosoft Edge...'
echo '-----------------'
echo
sleep 2
sudo sh -c << EOF "curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
echo 'deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main' > /etc/apt/sources.list.d/microsoft-edge-dev.list
rm microsoft.gpg
apt update
apt install microsoft-edge-dev
EOF
sleep 1
echo
	