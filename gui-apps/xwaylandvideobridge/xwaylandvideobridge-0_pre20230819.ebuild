# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=5.106.0
QTMIN=5.15.9
KDE_ORG_CATEGORY="system"
KDE_ORG_COMMIT="8842032fe672575a9dfe44adc7ef84b468d931fe"
inherit ecm kde.org

DESCRIPTION="Screenshare Wayland windows to XWayland apps"
HOMEPAGE="https://planet.kde.org/david-edmundson-2023-03-22-fixing-wayland-xwayland-screen-casting/
https://invent.kde.org/system/xwaylandvideobridge"

if [[ ${KDE_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64"
fi

LICENSE="GPL-2+"
SLOT="0"

DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtx11extras-${QTMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-plasma/kpipewire-5.27.4:5
	media-libs/freetype
	x11-libs/libxcb:=
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	ecm_src_prepare
	# https://invent.kde.org/system/xwaylandvideobridge/-/merge_requests/14
	ecm_punt_kf_module WidgetsAddons
}
