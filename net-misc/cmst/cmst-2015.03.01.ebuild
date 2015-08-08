# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit multilib qmake-utils

DESCRIPTION="Qt GUI for Connman with system tray icon"
HOMEPAGE="https://github.com/andrew-bibb/cmst"
SRC_URI="${HOMEPAGE}/archive/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	net-misc/connman
	x11-libs/libxkbcommon"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${P}"

src_prepare() {
	sed -i misc/desktop/cmst.desktop \
		-e 's/Version=1.1/Version=1.0/' \
		-e '/Categories/ s/$/;/'
}

src_configure() {
	export USE_LIBPATH="${EPREFIX}/usr/$(get_libdir)/${PN}"
	eqmake5
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}
