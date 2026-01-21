# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="forceoptional"
KFMIN=6.22.0
QTMIN=6.10.1
inherit ecm plasma.kde.org pam xdg

DESCRIPTION="Library and components for secure lock screen architecture"

LICENSE="GPL-2" # TODO: CHECK
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE=""

# requires running environment w/ RDEPENDs (circular dep w/ plasma-workspace)
RESTRICT="test"

# qtbase slot op: GuiPrivate use in greeter
COMMON_DEPEND="
	dev-libs/wayland
	>=dev-qt/qtbase-${QTMIN}:6=[dbus,gui,network,widgets]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=kde-frameworks/kcmutils-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6[qml]
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/kglobalaccel-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kidletime-${KFMIN}:6
	>=kde-frameworks/kio-6.22.1:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/kpackage-${KFMIN}:6
	>=kde-frameworks/ksvg-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	>=kde-frameworks/solid-${KFMIN}:6
	>=kde-plasma/layer-shell-qt-${KDE_CATV}:6
	>=kde-plasma/libplasma-${KDE_CATV}:6
	>=kde-plasma/libkscreen-${KDE_CATV}:6
	sys-libs/pam
	x11-libs/libX11
	x11-libs/libXi
	x11-libs/libxcb
	x11-libs/xcb-util-keysyms
"
DEPEND="${COMMON_DEPEND}
	x11-base/xorg-proto
"
RDEPEND="${COMMON_DEPEND}
	>=kde-frameworks/kdeclarative-${KFMIN}:6
	>=kde-frameworks/kirigami-${KFMIN}:6
	>=kde-plasma/libplasma-${KDE_CATV}:6
"
BDEPEND="
	dev-util/wayland-scanner
	>=kde-frameworks/kcmutils-${KFMIN}:6
"
PDEPEND=">=kde-plasma/plasma-workspace-${KDE_CATV}:6"

src_install() {
	ecm_src_install

	newpamd "${FILESDIR}/kde-r1.pam" kde
	newpamd "${FILESDIR}/kde-fingerprint.pam" kde-fingerprint
	newpamd "${FILESDIR}/kde-smartcard.pam" kde-smartcard
}
