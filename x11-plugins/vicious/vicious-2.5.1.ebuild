# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit optfeature

DESCRIPTION="Modular widget library for x11-wm/awesome"
HOMEPAGE="https://github.com/vicious-widgets/vicious"
SRC_URI="https://github.com/${PN}-widgets/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~riscv ~x86"
IUSE="contrib"

RDEPEND="x11-wm/awesome"

src_install() {
	insinto /usr/share/awesome/lib/vicious
	doins -r widgets spawn.lua helpers.lua init.lua

	if use contrib; then
		insinto /usr/share/awesome/lib/vicious/contrib
		doins contrib/*.lua
	fi

	einstalldocs
}

pkg_postinst() {
	# Note that as of 2.5.1 this list may or may not be incomplete  - it has been produced
	# only by searching for occurrences of vicious.spawn (the recommended way of calling
	# external helpers because it supports async) and popen (still used by many contrib widgets).
	# Moreover, dependencies of all non-Linux widgets have been excluded on purpose.
	optfeature_header "These widgets need some dependencies:"
	optfeature "cmus" "media-sound/cmus"
	optfeature "fs" "sys-apps/coreutils" # df
	optfeature "gmail" "net-misc/curl"
	optfeature "hddtemp" "net-misc/curl[telnet] app-admin/hddtemp"
	optfeature "hwmontemp" "sys-apps/grep"
	optfeature "mdir" "sys-apps/findutils"
	optfeature "mpd" "net-misc/curl[telnet] media-sound/mpd"
	optfeature "notmuch" "net-mail/notmuch"
	optfeature "volume" "media-sound/alsa-utils" # amixer
	optfeature "weather" "net-misc/curl"
	optfeature "wifi" "net-wireless/wireless-tools"
	optfeature "wifiiw" "net-wireless/iw"
	if use contrib; then
		optfeature "contrib/btc" "net-misc/curl"
		optfeature "contrib/buildbot" "net-misc/curl"
		optfeature "contrib/countfiles" "sys-apps/findutils"
		optfeature "contrib/mpc" "media-sound/mpc"
		optfeature "contrib/openweather" "net-misc/curl"
		optfeature "contrib/netcfg" "sys-apps/coreutils" # ls
		optfeature "contrib/nvinf" "x11-drivers/nvidia-drivers" # nvidia-settings
		# ossvol needs 'ossmix' - not packaged?
		optfeature "contrib/pulse" "media-sound/pulseaudio" # pacmd
		optfeature "contrib/rss" "net-misc/curl"
		optfeature "contrib/sensors" "sys-apps/lm-sensors"
		optfeature "contrib/wpa" "net-wireless/wpa_supplicant" # wpa-cli
	fi
	elog
}
