# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=5.247.0
PVCUT=$(ver_cut 1-3)
QTMIN=6.6.0
inherit ecm plasma.kde.org

DESCRIPTION="Syncs KDE Plasma theme settings to GTK applications"
HOMEPAGE="https://invent.kde.org/plasma/kde-gtk-config"

LICENSE="GPL-3"
SLOT="6"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-libs/glib:2
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui]
	>=dev-qt/qtsvg-${QTMIN}:6
	gnome-base/gsettings-desktop-schemas
	>=kde-frameworks/kcolorscheme-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/kguiaddons-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6
	>=kde-plasma/kdecoration-${PVCUT}:6
	x11-libs/gtk+:3[X]
"
RDEPEND="${DEPEND}
	>=kde-plasma/kde-cli-tools-${PVCUT}:*
	x11-misc/xsettingsd
"
BDEPEND="dev-lang/sassc"

src_configure() {
	local mycmakeargs=(
		-DDATA_INSTALL_DIR="${EPREFIX}/usr/share"
	)

	ecm_src_configure
}

pkg_postinst() {
	ecm_pkg_postinst
	elog "If you notice missing icons in your GTK applications, you may have to install"
	elog "the corresponding themes for GTK. A good guess would be x11-themes/oxygen-gtk"
	elog "for example."
}
