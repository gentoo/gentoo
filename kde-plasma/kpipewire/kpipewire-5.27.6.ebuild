# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="true"
KFMIN=5.106.0
QTMIN=5.15.9
inherit ecm plasma.kde.org

DESCRIPTION="Components relating to Flatpak pipewire use in Plasma"

LICENSE="LGPL-2.1+"
SLOT="5"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE=""

COMMON_DEPEND="
	dev-libs/wayland
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwayland-${QTMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kwayland-${KFMIN}:5
	media-libs/libepoxy
	media-libs/libglvnd
	media-video/ffmpeg:=
	>=media-video/pipewire-0.3:=
	x11-libs/libdrm
"
DEPEND="${COMMON_DEPEND}
	dev-libs/plasma-wayland-protocols
"
RDEPEND="${COMMON_DEPEND}
	>=dev-qt/qtquickcontrols2-${QTMIN}:5
	>=kde-frameworks/kirigami-${KFMIN}:5
	x11-themes/sound-theme-freedesktop
"
BDEPEND=">=dev-qt/qtwaylandscanner-${QTMIN}:5"
