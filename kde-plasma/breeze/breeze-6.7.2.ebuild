# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=6.26.0
QTMIN=6.10.1
inherit ecm plasma.kde.org xdg

DESCRIPTION="Breeze visual style for the Plasma desktop"
HOMEPAGE="https://invent.kde.org/plasma/breeze"

LICENSE="GPL-2" # TODO: CHECK
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE=""

# kde-frameworks/kwindowsystem[X]: Unconditional use of KX11Extras
DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,widgets]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=dev-qt/qtsvg-${QTMIN}:6
	>=kde-frameworks/frameworkintegration-${KFMIN}:6
	>=kde-frameworks/kcmutils-${KFMIN}:6
	>=kde-frameworks/kcolorscheme-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kguiaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6[X]
	>=kde-plasma/kdecoration-${KDE_CATV}:6
"
RDEPEND="${DEPEND}
	!<${CATEGORY}/${PN}-6.5.0:5
"
BDEPEND=">=kde-frameworks/kcmutils-${KFMIN}:6"
PDEPEND=">=kde-frameworks/breeze-icons-${KFMIN}:*"

src_configure() {
	local mycmakeargs=(
		-DBUILD_QT5=OFF
		-DBUILD_QT6=ON
		 # TODO: Consider build options? # bug 911205
		-DWITH_DECORATIONS=ON
		-DWITH_WALLPAPERS=ON
		-DBUILD_CURSOR=ON
		-DBUILD_WITH_QTQUICK=ON # qtdeclarative
	)
	ecm_src_configure
}
