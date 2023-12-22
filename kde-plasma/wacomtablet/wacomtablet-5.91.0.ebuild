# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
KFMIN=5.247.0
PVCUT=$(ver_cut 1-3)
QTMIN=6.6.0
inherit ecm plasma.kde.org

DESCRIPTION="Wacom system settings module that supports different button/pen layout profiles"
HOMEPAGE="https://userbase.kde.org/Wacomtablet"

LICENSE="GPL-2"
SLOT="6"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	>=dev-libs/libwacom-0.30:=
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,widgets]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=kde-frameworks/kcmutils-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/kglobalaccel-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	>=kde-plasma/libplasma-${PVCUT}:6
	>=kde-plasma/plasma5support-${PVCUT}:6
	>=x11-drivers/xf86-input-wacom-0.20.0
	x11-libs/libXi
	x11-libs/libxcb
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
	x11-libs/libX11
"
BDEPEND="sys-devel/gettext"

src_test() {
	# test needs DBus, bug 675548
	local myctestargs=(
		-E "(Test.KDED.DBusTabletService)"
	)

	ecm_src_test
}
