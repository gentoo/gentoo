# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="true"
KFMIN=6.18.0
QTMIN=6.10.1
inherit ecm plasma.kde.org xdg

DESCRIPTION="Components relating to Flatpak pipewire use in Plasma"

LICENSE="LGPL-2.1+"
SLOT="6"
KEYWORDS="amd64 arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE=""

RESTRICT="test" # bug 964943

COMMON_DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,opengl]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	media-libs/libepoxy
	media-libs/libglvnd
	media-libs/libva:=
	media-libs/mesa[opengl]
	>=media-video/ffmpeg-6.1:=
	>=media-video/pipewire-0.3:=
	x11-libs/libdrm
"
DEPEND="${COMMON_DEPEND}
	test? (
		dev-libs/plasma-wayland-protocols
		dev-libs/wayland
		>=dev-qt/qtbase-${QTMIN}:6[wayland]
		>=kde-plasma/kwayland-${KDE_CATV}:6
		media-video/pipewire[extra]
	)
"
RDEPEND="${COMMON_DEPEND}
	>=kde-frameworks/kirigami-${KFMIN}:6
"
BDEPEND="test? ( >=dev-qt/qtbase-${QTMIN}:6[wayland] )"
