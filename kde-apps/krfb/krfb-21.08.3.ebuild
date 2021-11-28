# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
KFMIN=5.84.0
QTMIN=5.15.2
inherit ecm kde.org

DESCRIPTION="VNC-compatible server to share Plasma desktops"
HOMEPAGE="https://apps.kde.org/krfb/"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="amd64 arm64 ~ppc64 ~riscv ~x86"
IUSE="wayland"

COMMON_DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtx11extras-${QTMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/kdnssd-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/kwallet-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=net-libs/libvncserver-0.9.9
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXtst
	x11-libs/xcb-util-image
	wayland? (
		media-libs/libepoxy
		media-libs/mesa[gbm(+)]
		>=media-video/pipewire-0.3:=
	)
"
DEPEND="${COMMON_DEPEND}
	wayland? ( media-libs/libglvnd )
"
RDEPEND="${COMMON_DEPEND}
	wayland? ( sys-apps/xdg-desktop-portal[screencast] )
"

src_prepare() {
	ecm_src_prepare

	# TODO: try to get a build switch upstreamed
	if ! use wayland; then
		sed -e "s/^pkg_check_modules.*PipeWire/#&/" -i CMakeLists.txt || die
	fi
}
