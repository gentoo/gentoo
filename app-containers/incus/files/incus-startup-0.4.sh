#!/bin/sh
set -e

case "$1" in
    start)
      systemctl is-active incus -q && exit 0
      exec incusd activateifneeded
    ;;

    stop)
      systemctl is-active incus -q || exit 0
      exec incusd shutdown
    ;;

    *)
        echo "unknown argument \`$1'" >&2
        exit 1
    ;;
esac

exit 0
