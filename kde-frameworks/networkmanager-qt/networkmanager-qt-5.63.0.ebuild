# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit kde5

DESCRIPTION="NetworkManager bindings for Qt"
LICENSE="LGPL-2"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="teamd"

BDEPEND="
	virtual/pkgconfig
"
DEPEND="
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtnetwork)
	>=net-misc/networkmanager-1.4.0-r1[teamd=]
"
RDEPEND="${DEPEND}
	|| (
		>=net-misc/networkmanager-1.4.0-r1[consolekit]
		>=net-misc/networkmanager-1.4.0-r1[elogind]
		>=net-misc/networkmanager-1.4.0-r1[systemd]
	)
"

src_test() {
	# bug: 625276
	local myctestargs=( -E "(managertest|settingstest|activeconnectiontest)" )

	kde5_src_test
}
