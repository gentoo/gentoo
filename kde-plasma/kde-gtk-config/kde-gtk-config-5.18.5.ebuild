# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KFMIN=5.66.0
PVCUT=$(ver_cut 1-3)
QTMIN=5.12.3
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="GTK2 and GTK3 configurator for KDE Plasma"
HOMEPAGE="https://invent.kde.org/plasma/kde-gtk-config"

LICENSE="GPL-3"
SLOT="5"
KEYWORDS="amd64 ~arm arm64 ~ppc64 x86"
IUSE=""

DEPEND="
	dev-libs/glib:2
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	gnome-base/gsettings-desktop-schemas
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	x11-libs/gtk+:2
	x11-libs/gtk+:3
"
RDEPEND="${DEPEND}
	>=kde-plasma/kde-cli-tools-${PVCUT}:5
"

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
