#!/sbin/openrc-run
# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Header: $

# Init script from Debian

depend() {
        after local
}

start() {
	einfo "System boot completed"
	if [ ! -c /dev/input/by-path/platform-gpio-keys-event- ]; then
		eerror "qcontrol error: gpio_keys device not available"
		return 1
	fi
	start-stop-daemon --start --quiet --background --pidfile /var/run/qcontrol.pid --make-pidfile --exec /usr/sbin/qcontrol -- -d
	# Change status led to show green
	device=$(grep "Hardware[[:space:]]*:" /proc/cpuinfo 2>/dev/null | \
		 head -n1 | sed "s/^[^:]*: //")
	case $device in
	    "QNAP TS-109/TS-209" | "QNAP TS-119/TS-219")
			qcontrol statusled greenon || true
			qcontrol powerled on || true
			if [ "$SOUND_BUZZER" != no ]; then
				qcontrol buzzer short || true
			fi
		;;
	    "QNAP TS-409" | "QNAP TS-41x")
			qcontrol statusled greenon || true
			if [ "$SOUND_BUZZER" != no ]; then
				qcontrol buzzer short || true
			fi
		;;
	    *)
		eerror "qcontrol error: device is not supported"
		;;
	esac
        start-stop-daemon --stop --quiet --pidfile /var/run/qcontrol.pid --name qcontrol
	rm /var/run/qcontrol.sock
}

stop() {
	einfo "Shutting down system"
	if [ ! -c /dev/input/by-path/platform-gpio-keys-event- ]; then
		eerror "qcontrol error: gpio_keys device not available"
		return 1
	fi
	start-stop-daemon --start --quiet --background --pidfile /var/run/qcontrol.pid --make-pidfile --exec /usr/sbin/qcontrol -- -d
	# Change status led to show red
	device=$(grep "Hardware[[:space:]]*:" /proc/cpuinfo 2>/dev/null | \
		 head -n1 | sed "s/^[^:]*: //")
	case $device in
	    "QNAP TS-109/TS-209" | "QNAP TS-119/TS-219")
			qcontrol statusled rednon || true
			qcontrol powerled 1hz || true
			if [ "$SOUND_BUZZER" != no ]; then
				qcontrol buzzer short || true
			fi
		;;
	    "QNAP TS-409" | "QNAP TS-41x")
			qcontrol statusled redon || true
			if [ "$SOUND_BUZZER" != no ]; then
				qcontrol buzzer short || true
			fi
		;;
	    *)
		eerror "qcontrol error: device is not supported"
		;;
	esac
        start-stop-daemon --stop --quiet --pidfile /var/run/qcontrol.pid --name qcontrol
	rm /var/run/qcontrol.sock
}
