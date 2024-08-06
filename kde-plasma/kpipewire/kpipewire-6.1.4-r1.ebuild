# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="true"
PVCUT=$(ver_cut 1-3)
KFMIN=6.3.0
QTMIN=6.7.1
inherit ecm plasma.kde.org

DESCRIPTION="Components relating to Flatpak pipewire use in Plasma"

LICENSE="LGPL-2.1+"
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE=""

RESTRICT="test" # bug 926511, fixed in 6.2

COMMON_DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	media-libs/libepoxy
	media-libs/libglvnd
	media-libs/libva:=
	media-libs/mesa[opengl]
	media-video/ffmpeg:=
	>=media-video/pipewire-0.3:=
	x11-libs/libdrm
"
DEPEND="${COMMON_DEPEND}
	test? (
		dev-libs/plasma-wayland-protocols
		dev-libs/wayland
		>=dev-qt/qtwayland-${QTMIN}:6
		>=kde-plasma/kwayland-${PVCUT}:6
	)
"
RDEPEND="${COMMON_DEPEND}
	>=kde-frameworks/kirigami-${KFMIN}:6
	x11-themes/sound-theme-freedesktop
"
BDEPEND="test? ( >=dev-qt/qtwayland-${QTMIN}:6 )"
