# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="optional"
ECM_TEST="forceoptional"
KFMIN=6.18.0
QTMIN=6.10.1
inherit ecm fcaps plasma.kde.org xdg

DESCRIPTION="Power management for KDE Plasma Shell"
HOMEPAGE="https://invent.kde.org/plasma/powerdevil"

LICENSE="GPL-2" # TODO: CHECK
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="brightness-control"

RESTRICT="test" # bug 926513

# slot op: Uses Qt::GuiPrivate for qtx11extras_p.h
COMMON_DEPEND="
	dev-libs/qcoro[dbus]
	dev-libs/wayland
	>=dev-qt/qtbase-${QTMIN}:6=[dbus,gui,wayland,widgets]
	>=kde-frameworks/kauth-${KFMIN}:6[policykit]
	>=kde-frameworks/kcmutils-${KFMIN}:6
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
	>=kde-plasma/libkscreen-${KDE_CATV}:6
	>=kde-plasma/libplasma-${KDE_CATV}:6
	>=kde-plasma/plasma-activities-${KDE_CATV}:6=
	>=kde-plasma/plasma-workspace-${KDE_CATV}:6
	virtual/libudev:=
	x11-libs/libxcb
	brightness-control? ( app-misc/ddcutil:= )
"
DEPEND="${COMMON_DEPEND}
	>=dev-libs/plasma-wayland-protocols-1.19.0
"
RDEPEND="${COMMON_DEPEND}
	!<kde-plasma/plasma-workspace-6.1.90:*
	>=dev-qt/qtdeclarative-${QTMIN}:6
	|| (
		sys-apps/tuned[ppd]
		sys-power/power-profiles-daemon
		sys-power/tlp
	)
	>=sys-power/upower-0.9.23
"
BDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[wayland]
	dev-util/wayland-scanner
	>=kde-frameworks/kcmutils-${KFMIN}:6
"

# -m 0755 to avoid suid with USE="-filecaps"
FILECAPS=( -m 0755 cap_wake_alarm=ep usr/libexec/org_kde_powerdevil )

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package brightness-control DDCUtil)
	)
	use test && mycmakeargs+=(
		-DCMAKE_DISABLE_FIND_PACKAGE_SeleniumWebDriverATSPI=ON # not packaged
	)

	ecm_src_configure
}

src_test() {
	# bug 926513
	ecm_src_test -j1
}

pkg_postinst() {
	if has_version "<sys-apps/systemd-257"; then
		ewarn "org_kde_powerdevil won't start under systemd user session."
		ewarn "You must upgrade to >=sys-apps/systemd-257. Bug #956312"
	fi
	xdg_pkg_postinst
	fcaps_pkg_postinst
}
