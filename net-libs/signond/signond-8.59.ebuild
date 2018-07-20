# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit qmake-utils vcs-snapshot

DESCRIPTION="Signon daemon for libaccounts-glib"
HOMEPAGE="https://01.org/gsso/"
SRC_URI="https://gitlab.com/accounts-sso/signond/repository/archive.tar.gz?ref=VERSION_8.59 -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="doc test"

RESTRICT="test"

COMMON_DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtsql:5
	net-libs/libproxy
"
DEPEND="${COMMON_DEPEND}
	doc? ( app-doc/doxygen )
	test? ( dev-qt/qttest:5 )
"
RDEPEND="${COMMON_DEPEND}
	!<net-libs/libproxy-0.4.12[kde]
"
# <libproxy-0.4.12[kde] results in segfaults due to symbol collisions with qt4

src_prepare() {
	default

	# remove unused dependency
	sed -e "/xml \\\/d" -i src/signond/signond.pro || die

	# ensure qt5 version of binary is used
	sed -e "s|qdbusxml2cpp|$(qt5_get_bindir)/&|" -i src/signond/signond.pro || die

	# install docs to correct location
	sed -e "s|share/doc/\$\${PROJECT_NAME}|share/doc/${PF}|" -i doc/doc.pri || die

	# don't install example plugin
	sed -e "/example/d" -i src/plugins/plugins.pro || die

	# make tests optional
	use test || sed -i -e '/^SUBDIRS/s/tests//' signon.pro || die "couldn't disable tests"

	# make docs optional
	use doc || sed -e "/include(\s*doc\/doc.pri\s*)/d" -i \
		signon.pro -i lib/SignOn/SignOn.pro lib/plugins/plugins.pro || die
}

src_configure() {
	eqmake5
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}
