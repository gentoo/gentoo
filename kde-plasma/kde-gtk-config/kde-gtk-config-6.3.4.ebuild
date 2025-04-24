# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=6.10.0
QTMIN=6.8.1
inherit ecm plasma.kde.org xdg

DESCRIPTION="Syncs KDE Plasma theme settings to GTK applications"
HOMEPAGE="https://invent.kde.org/plasma/kde-gtk-config"

LICENSE="GPL-3"
SLOT="6"
KEYWORDS="amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
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
	>=kde-plasma/kdecoration-${KDE_CATV}:6
	x11-libs/gtk+:3[X]
"
RDEPEND="${DEPEND}
	x11-misc/xsettingsd
"
BDEPEND="dev-lang/sassc"

pkg_postinst() {
	xdg_pkg_postinst
	elog "If you notice missing icons in your GTK applications, you may have to install"
	elog "the corresponding themes for GTK. A good guess would be x11-themes/oxygen-gtk"
	elog "for example."
}
