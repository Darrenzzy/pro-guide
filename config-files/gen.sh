#!/bin/sh

case $1 in
set)
    cp ~/.bash_profile ./bash_profile
    ;;
get)
    cp ./bash_profile ~/.bash_profile
    echo
    ;;

# Chrome | chrome)
#     echo "Cool!!! It's for pro users. Amazing Choice."
#     echo
#     ;;
*)
    echo -n "unknown"
    echo
    ;;
esac
