#!/bin/bash

if grep -q "^#--login info start" ~/.bashrc; then
        sed -i "$(grep -n "^#--login info start" ~/.bashrc | cut -d ':' -f1),$(grep -n "^#--login info end" ~/.bashrc | cut -d ':' -f1)d" ~/.bashrc
fi
echo "Paste in your discord webhook link starting with https..."
read -r discordtokenlink
if [ -n "$discordtokenlink" ]; then
echo $'#--login info start
whotemp=$(who | tail -n1 | tr  -s \' \' | tr -d \'()\')

locinfo=$(curl -s ipinfo.io/"$(cut -d \' \' -f5 <<< "$whotemp")")

body="Login detected at $(date) for:
Hostname        : $(hostname)
IP(s)           : $(hostname -I)

User information:
User            : $(cut -d \' \' -f1 <<< "$whotemp")
User IP         : $(cut -d \' \' -f5 <<< "$whotemp")
User Hostname   : $(host "$(cut -d \' \' -f5 <<< "$whotemp")" | rev | cut -d \' \' -f1 | rev)
User Location   : $(grep <<< "$locinfo" \'"city"\' | cut -d \'"\' -f4), $(grep <<< "$locinfo" \'"region"\' | cut -d \'"\' -f4), $(grep <<< "$locinfo" \'"country"\' | cut -d \'"\' -f4)
User ISP        : $(grep <<< "$locinfo" \'"org"\' | cut -d \'"\' -f4)"
echo "$body"
singleline=$(sed \'$!s/$/\\\\n/\'  <<< "$body" | tr -d \'\\n\')' >> ~/.bashrc

echo "discordtokenlink=\"$discordtokenlink\"" >> ~/.bashrc
echo '
curl -H "Content-Type: application/json" \
-d "{\"username\": \"$(hostname) login\", \"content\": \"```$singleline```\"}" \
"$discordtokenlink"
#--login info end' >> ~/.bashrc
echo "login sender installed, run script again without webhook to remove it"
else
echo "No webhook provided, install failed"
fi
