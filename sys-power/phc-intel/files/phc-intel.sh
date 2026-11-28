#!/bin/bash -e
## This file is licensed under the GNU General Public License, version 2.

VERSION=0.3.2
_conf='/etc/default/phc-intel'

msg() {
  printf '%s\n' "$@"
}

errmsg() {
  msg "$@" > /dev/stderr
}

check_conf_and_set() {
  if [ -r "${_conf}" ]; then
    . <(grep -Eo '[ \t^#]*VIDS="[0-9 ]*"[ \t]*$' "${_conf}")
    if [ -z "$VIDS" ]; then
      errmsg "=> Please edit '${_conf}'."
      exit 1
    fi
    msg ':: Setting PHC VIDs'
    for i in /sys/devices/system/cpu/cpu*/cpufreq/phc_vids; do
      echo "$VIDS" > "$i"
    done
  else
    errmsg "$0: Error: Config file '${_conf}' not present."
    exit 2
  fi
}

check_kernel_cmdline() {
  for i in $(< /proc/cmdline); do
    if [ "$i" = nophc ]; then
      errmsg "=> 'nophc' kernel option set, not setting PHC VIDs."
      errmsg "   Use '$0 force-set' to override."
      return 1
    fi
  done
}

shopt -s nullglob

case "$1" in

  start)
    check_kernel_cmdline "$@" || exit 0
    check_conf_and_set "$@"
  ;;

  stop)
    msg ':: Resetting default PHC VIDs'
    for i in /sys/devices/system/cpu/cpu*/cpufreq/phc_vids; do
      cp "${i%vids}default_vids" "$i"
    done
  ;;

  status)
    check_off () {
      for i in /sys/devices/system/cpu/cpu*/cpufreq/phc_vids; do
        [ "$(< "$i")" = "$(< "${i%vids}default_vids")" ] || return;
      done
    }
    check_on () {
      for i in /sys/devices/system/cpu/cpu*/cpufreq/phc_vids; do
        [[ "$(< "$i")" =~ "$VIDS" ]] || return;
      done
    }
    printf '%s' 'PHC status: '
    . <(grep -Eo '[ \t^#]*VIDS="[0-9 ]*"[ \t]*$' "${_conf}")
    if check_off; then
      msg 'inactive'
    elif check_on; then
      msg 'active'
    else
      msg 'unknown'
    fi
  ;;

  set)
    "$0" start
  ;;

  force-set)
    check_conf_and_set "$@"
  ;;

  reset)
    "$0" stop
  ;;

  --version)
    printf '%s\n' "${VERSION}"
  ;;

  *)
    echo "usage: $0 {start|stop|status|set|force-set|reset|--version}"
  ;;

esac
