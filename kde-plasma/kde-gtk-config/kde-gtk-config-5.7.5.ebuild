# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_TEST="forceoptional"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="KDE Plasma systemsettings kcm to set GTK application look&feel"
HOMEPAGE="https://projects.kde.org/kde-gtk-config"
LICENSE="GPL-3"
KEYWORDS="amd64 ~arm x86"
IUSE="+gtk3"

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
	x11-libs/libXcursor
	x11-libs/gtk+:2
	gtk3? ( x11-libs/gtk+:3 )
"
RDEPEND="${DEPEND}
	$(add_plasma_dep kde-cli-tools)
	!kde-base/kde-gtk-config:4
	!kde-plasma/kde-gtk-config:4
"

PATCHES=(
	"${FILESDIR}/${PN}-5.4.2-gtk3-optional.patch"
	"${FILESDIR}/${PN}-5.7.4-look-for-cursors-in-right-place.patch"
)

src_configure() {
	local mycmakeargs=(
		-DDATA_INSTALL_DIR="${EPREFIX}/usr/share"
		-DBUILD_gtk3proxies=$(usex gtk3)
	)

	kde5_src_configure
}

pkg_postinst() {
	kde5_pkg_postinst
	einfo
	elog "If you notice missing icons in your GTK applications, you may have to install"
	elog "the corresponding themes for GTK. A good guess would be x11-themes/oxygen-gtk"
	elog "for example."
	einfo
}
