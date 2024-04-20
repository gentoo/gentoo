# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: use various devices for controlling vdr (keyboards, lirc...)"
HOMEPAGE="http://www.escape-edv.de/endriss/vdr/"
SRC_URI="http://www.escape-edv.de/endriss/vdr/${P}.tgz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 x86"
IUSE="systemd"

DEPEND=">=media-video/vdr-2.2.0"

pkg_setup() {
	vdr-plugin-2_pkg_setup

	if use systemd; then
		if ! getent group input | grep -q vdr; then
			einfo "add user 'vdr' to group 'input' for full access to remote control device"
			gpasswd -a vdr input
		fi
	fi
}
