# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit qmake-utils xdg-utils

DESCRIPTION="Qt GUI for Connman with system tray icon"
HOMEPAGE="https://github.com/andrew-bibb/cmst"
SRC_URI="https://github.com/andrew-bibb/cmst/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
"
RDEPEND="${DEPEND}
	net-misc/connman
"

src_configure() {
	export USE_LIBPATH="${EPREFIX}/usr/$(get_libdir)/${PN}"
	eqmake5 DISTRO=gentoo
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	rm -r "${D}"/usr/share/licenses || die
	gunzip "${D}"/usr/share/man/man1/cmst.1.gz
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
