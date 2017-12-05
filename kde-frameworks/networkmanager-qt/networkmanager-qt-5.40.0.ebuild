# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit kde5

DESCRIPTION="NetworkManager bindings for Qt"
LICENSE="LGPL-2"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="teamd"

COMMON_DEPEND="
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtnetwork)
	|| (
		>=net-misc/networkmanager-1.4.0-r1[consolekit,teamd=]
		>=net-misc/networkmanager-1.4.0-r1[elogind,teamd=]
		>=net-misc/networkmanager-1.4.0-r1[systemd,teamd=]
	)
"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
"
RDEPEND="${COMMON_DEPEND}
	!net-libs/libnm-qt:5
"

src_test() {
	# bug: 625276
	local myctestargs=( -E "(managertest|settingstest|activeconnectiontest)" )

	kde5_src_test
}
