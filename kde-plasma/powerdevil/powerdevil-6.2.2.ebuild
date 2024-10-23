# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
ECM_TEST="forceoptional"
KFMIN=6.6.0
PVCUT=$(ver_cut 1-3)
QTMIN=6.7.2
inherit ecm plasma.kde.org

DESCRIPTION="Power management for KDE Plasma Shell"
HOMEPAGE="https://invent.kde.org/plasma/powerdevil"

LICENSE="GPL-2" # TODO: CHECK
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="brightness-control caps"

RESTRICT="test" # bug 926513

# slot op: Uses Qt::GuiPrivate for qtx11extras_p.h
DEPEND="
	dev-libs/qcoro[dbus]
	dev-libs/wayland
	>=dev-qt/qtbase-${QTMIN}:6=[dbus,gui,widgets]
	>=dev-qt/qtwayland-${QTMIN}:6=
	>=kde-frameworks/kauth-${KFMIN}:6[policykit]
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/kglobalaccel-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kidletime-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kirigami-${KFMIN}:6
	>=kde-frameworks/kitemmodels-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/krunner-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6[X]
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	>=kde-frameworks/solid-${KFMIN}:6
	>=kde-plasma/libkscreen-${PVCUT}:6
	>=kde-plasma/libplasma-${PVCUT}:6
	>=kde-plasma/plasma-activities-${PVCUT}:6
	>=kde-plasma/plasma-workspace-${PVCUT}:6
	virtual/libudev:=
	x11-libs/libxcb
	brightness-control? ( app-misc/ddcutil:= )
	caps? ( sys-libs/libcap )
"
RDEPEND="${DEPEND}
	!<kde-plasma/plasma-workspace-6.1.90:6
	>=dev-libs/plasma-wayland-protocols-1.14.0
	>=dev-qt/qtdeclarative-${QTMIN}:6
	sys-power/power-profiles-daemon
	>=sys-power/upower-0.9.23
"
BDEPEND="
	>=dev-qt/qtwayland-${QTMIN}:6
	>=kde-frameworks/kcmutils-${KFMIN}:6
"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_SeleniumWebDriverATSPI=ON # not packaged
		$(cmake_use_find_package brightness-control DDCUtil)
		$(cmake_use_find_package caps Libcap)
	)

	ecm_src_configure
}

src_test() {
	# bug 926513
	ecm_src_test -j1
}
