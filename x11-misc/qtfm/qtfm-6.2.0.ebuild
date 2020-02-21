# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit xdg-utils qmake-utils

DESCRIPTION="A small, lightweight file manager for desktops based on pure Qt"
HOMEPAGE="https://qtfm.eu/"
SRC_URI="https://github.com/rodlie/qtfm/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+dbus shared"

RDEPEND="
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	sys-apps/file
	dbus? ( dev-qt/qtdbus:5 )
"
DEPEND="
	${RDEPEND}
	app-arch/unzip
	dev-qt/linguist-tools:5
"

src_configure() {
	eqmake5 \
		$(usex dbus '' 'CONFIG+=no_dbus CONFIG+=no_tray') \
		$(usex shared 'CONFIG+=sharedlib' '') \
		$(usex shared 'CONFIG+=with_includes' '') \
		LIBDIR="/usr/$(get_libdir)" \
		PREFIX="/usr" \
		XDGDIR="/etc/xdg"
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
