# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_PN="signon"
MY_P="${MY_PN}-${PV}"
inherit qmake-utils

DESCRIPTION="Signon daemon for libaccounts-glib"
HOMEPAGE="https://01.org/gsso/"
SRC_URI="http://dev.gentoo.org/~kensington/distfiles/${MY_P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

RESTRICT="test"

# libproxy[kde] results to segfaults
RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtsql:5
	net-libs/libproxy[-kde]
"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	test? ( dev-qt/qttest:5 )
"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}/${P}-qt55.patch"

	sed -e "s|qdbusxml2cpp|$(qt5_get_bindir)/&|" -i src/signond/signond.pro || die
	sed -e "s|share/doc/\$\${PROJECT_NAME}|share/doc/${PF}|" -i doc/doc.pri || die
	use test || sed -i -e '/^SUBDIRS/s/tests//' signon.pro || die "couldn't disable tests"
	use doc || sed -e "/include(\s*doc\/doc.pri\s*)/d" -i \
		${MY_PN}.pro -i lib/SignOn/SignOn.pro lib/plugins/plugins.pro || die
}

src_configure() {
	eqmake5
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}
