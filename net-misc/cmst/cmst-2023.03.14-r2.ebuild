# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils xdg-utils

DESCRIPTION="Qt GUI for Connman with system tray icon"
HOMEPAGE="https://github.com/andrew-bibb/cmst"
SRC_URI="https://github.com/andrew-bibb/cmst/archive/${P}.tar.gz"
S="${WORKDIR}/${PN}-${P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="dev-qt/qtbase:6[dbus,gui,network,widgets]"
RDEPEND="${DEPEND}
	net-misc/connman
"
BDEPEND="dev-qt/qttools:6[linguist]"

src_configure() {
	export USE_LIBPATH="${EPREFIX}/usr/$(get_libdir)/${PN}"
	eqmake6 DISTRO=gentoo
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
