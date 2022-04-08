#/bin/bash

#status=dwm
status=waybar

if [ $status == dwm ]; then
    prefix_down="^c#3ec13f^▾^d^"
    prefix_up="^c#fe522c^▴^d^"
    output="/tmp/network"
elif [ $status == waybar ]; then
    prefix_down="<span color='#3ec13f'>▾</span>"
    prefix_up="<span color='#f3522c'>▴</span>"
    output="/dev/stdout"
fi
declare lastTotal=(0 0)
while true; do
    declare wltotal=($(grep -e "wl" /proc/net/dev | awk '{printf "%d %d", $2/1024, $10/1024}'))
    declare ethtotal=($(grep -e "en" -e "eth" /proc/net/dev | awk '{printf "%d %d", $2/1024, $10/1024}'))
    declare total=($((${wltotal[0]}+${ethtotal[0]})) $((${wltotal[1]}+${ethtotal[1]})))
    printf "$prefix_down %4dkB | $prefix_up %4dkB\n" $((${total[0]}-${lastTotal[0]})) $((${total[1]}-${lastTotal[1]})) > $output
    lastTotal=(${total[@]})
    sleep 1
done
