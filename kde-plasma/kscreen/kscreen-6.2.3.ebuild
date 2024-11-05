# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="forceoptional"
KFMIN=6.6.0
PVCUT=$(ver_cut 1-3)
QTMIN=6.7.2
inherit ecm plasma.kde.org

DESCRIPTION="KDE Plasma screen management"
HOMEPAGE="https://invent.kde.org/plasma/kscreen"

LICENSE="GPL-2" # TODO: CHECK
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="X"

# bug #580440, last checked 5.6.3
RESTRICT="test"

# qtbase slot op: GuiPrivate use in kded daemon
DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,widgets]
	>=dev-qt/qtdeclarative-${QTMIN}:6[widgets]
	>=dev-qt/qtsensors-${QTMIN}:6
	>=kde-frameworks/kcmutils-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/kglobalaccel-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/ksvg-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	>=kde-plasma/layer-shell-qt-${PVCUT}:6
	>=kde-plasma/libkscreen-${PVCUT}:6=
	>=kde-plasma/libplasma-${PVCUT}:6
	X? (
		>=dev-qt/qtbase-${QTMIN}:6=[X]
		x11-libs/libX11
		x11-libs/libxcb:=
		x11-libs/libXi
	)
"
RDEPEND="${DEPEND}
	>=dev-qt/qt5compat-${QTMIN}:6[qml]
"
BDEPEND=">=kde-frameworks/kcmutils-${KFMIN}:6"

src_configure() {
	local mycmakeargs=(
		-DWITH_X11=$(usex X)
	)
	ecm_src_configure
}
