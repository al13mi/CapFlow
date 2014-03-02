#!/bin/sh
ovsdb-server --remote=punix:/usr/local/var/run/openvswitch/db.sock \
                     --remote=db:Open_vSwitch,Open_vSwitch,manager_options \
                     --private-key=db:Open_vSwitch,SSL,private_key \
                     --certificate=db:Open_vSwitch,SSL,certificate \
                     --bootstrap-ca-cert=db:Open_vSwitch,SSL,ca_cert \
                     --pidfile --detach
                     
ovs-vswitchd --pidfile --detach

sudo ovs-vsctl set bridge switch protocols=OpenFlow13

ovs-vsctl add-br switch

ip link add A type veth peer name B
ifconfig A up
ifconfig B up
ip link add C type veth peer name D
ifconfig C up
ifconfig D up

ovs-vsctl add-port switch B
ovs-vsctl add-port switch D

ovs-vsctl set Bridge switch other-config:datapath-id=0000000000000123
ovs-vsctl set-controller switch tcp:127.0.0.1:6633

echo "Press Enter to stop."
read CONTINUE

ovs-vsctl del-br switch
ovs-vsctl emer-reset
ip link delete A
ip link delete C
