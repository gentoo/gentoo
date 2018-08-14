# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_TEST="forceoptional"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="KDE Plasma systemsettings kcm to set GTK application look&feel"
HOMEPAGE="https://cgit.kde.org/kde-gtk-config.git"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep kcmutils)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep knewstuff)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	dev-libs/glib:2
	gnome-base/gsettings-desktop-schemas
	x11-libs/gtk+:2
	x11-libs/gtk+:3
	x11-libs/libXcursor
"
RDEPEND="${DEPEND}
	$(add_plasma_dep kde-cli-tools)
	!kde-plasma/kde-gtk-config:4
"

src_configure() {
	local mycmakeargs=(
		-DDATA_INSTALL_DIR="${EPREFIX}/usr/share"
	)

	kde5_src_configure
}

pkg_postinst() {
	kde5_pkg_postinst
	elog "If you notice missing icons in your GTK applications, you may have to install"
	elog "the corresponding themes for GTK. A good guess would be x11-themes/oxygen-gtk"
	elog "for example."
}
