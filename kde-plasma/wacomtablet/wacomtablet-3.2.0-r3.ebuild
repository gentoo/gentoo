# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
KFMIN=5.82.0
QTMIN=5.15.2
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="Wacom system settings module that supports different button/pen layout profiles"
HOMEPAGE="https://userbase.kde.org/Wacomtablet"
SRC_URI="mirror://kde/stable/${PN}/${PV}/${P}.tar.xz
https://dev.gentoo.org/~asturm/distfiles/${P}-patchset-1.tar.xz"

LICENSE="GPL-2"
SLOT="5"
KEYWORDS="amd64 x86"

RDEPEND="
	>=dev-libs/libwacom-0.30:=
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtx11extras-${QTMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/kglobalaccel-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-plasma/libplasma-${KFMIN}:5
	>=x11-drivers/xf86-input-wacom-0.20.0
	x11-libs/libXi
	x11-libs/libxcb
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
	x11-libs/libX11
"
BDEPEND="sys-devel/gettext"

PATCHES=(
	"${WORKDIR}/${P}-qt-5.15.patch"
	"${WORKDIR}/${P}-qt-5.15-obsoletions.patch"
	"${WORKDIR}/${P}-no-override-screenspace-w-missing-screen.patch" # KDE-bug 419392
	"${WORKDIR}/${P}-fix-xsetwacom-adapter.patch"
	"${WORKDIR}/${P}-Intuos-M-bluetooth.patch" # KDE-bug 418827
	"${WORKDIR}/${P}-correct-icons.patch"
	"${WORKDIR}/${P}-drop-empty-X-KDE-PluginInfo-Depends.patch"
	"${WORKDIR}/${P}-fix-QProcess-invocation.patch"
	"${WORKDIR}/${P}-turn-off-gesture-support-by-default.patch" # KDE-bug 440556
	"${WORKDIR}/${P}-only-show-on-X11.patch"
	"${FILESDIR}/${P}-port-to-QRegularExpression.patch" # pre-requisite for below:
	"${FILESDIR}/${P}-fix-incorrect-xsetwacom-call.patch" # bug 850652, KDE-bug 454947
)

src_test() {
	# test needs DBus, bug 675548
	local myctestargs=(
		-E "(Test.KDED.DBusTabletService)"
	)

	ecm_src_test
}
