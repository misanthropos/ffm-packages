#!/bin/sh
. /usr/share/libubox/jshn.sh

JSHN_DEBUG=0
JSHN_DEBUG_PREFIX="json_debug: "
json_init 

STATISTICS="$(mktemp -p /tmp)"
gluon-neighbour-info -d ::1 -p 1001 -c 1 -r statistics > $STATISTICS

json_load_file $STATISTICS

_set_var _json_no_warning 1

json_select "mesh_vpn"
json_select "groups"
json_select "backbone"
json_select "peers"

json_get_keys peers

for gw in $peers; do
    if json_select "$gw"; then
        json_get_keys values
        for key in $values; do
            json_get_var $key $key
        done
        if [ ! -z $method ]; then
            gwup="$(echo "$established" | cut -d '.' -f 1)"
            timestring=$(date -ud "@$gwup" +"$(( $gwup/3600/24 )) days %H hours %M minutes %S seconds")
            echo $gw: $method - established: $timestring
        fi
fi
done

json_load_file $STATISTICS
json_select memory
json_get_keys memitems

for memitem in $memitems; do
        for memitem in $memitems; do
                json_get_var $memitem $memitem
        done
done
echo "RAM: $total, free: $free, available: $available, buffers: $buffers, cached: $cached"

rm $STATISTICS
