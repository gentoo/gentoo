# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit qmake-utils

DESCRIPTION="Online accounts signon UI"
HOMEPAGE="https://launchpad.net/signon-ui"
SRC_URI="https://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.bz2"

LICENSE="GPL-2 GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RESTRICT="test"

# <libproxy-0.4.12[kde] results in segfaults due to symbol collisions with qt4
COMMON_DEPEND="
	dev-libs/glib:2
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtwebkit:5
	dev-qt/qtwidgets:5
	net-libs/accounts-qt
	net-libs/signond
	net-libs/libproxy
	x11-libs/libnotify
"
DEPEND="${COMMON_DEPEND}
	test? ( dev-qt/qttest:5 )
"
RDEPEND="${COMMON_DEPEND}
	!<net-libs/libproxy-0.4.12[kde]
"

src_prepare() {
	default

	if ! use test; then
		sed -i -e '/^SUBDIRS.*/,+1d' tests/tests.pro || die "couldn't disable tests"
	fi
}

src_configure() {
	eqmake5
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}
