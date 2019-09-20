# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2-utils qmake-utils

DESCRIPTION="Qt GUI for Connman with system tray icon"
HOMEPAGE="https://github.com/andrew-bibb/cmst"
SRC_URI="https://github.com/andrew-bibb/cmst/archive/${P}.tar.gz"

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

S="${WORKDIR}/${PN}-${P}"

src_configure() {
	export USE_LIBPATH="${EPREFIX}/usr/$(get_libdir)/${PN}"
	eqmake5 DISTRO=gentoo
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	rm -r "${D}"/usr/share/licenses || die
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
