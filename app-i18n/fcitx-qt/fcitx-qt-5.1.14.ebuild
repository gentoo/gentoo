# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="fcitx5-qt"

inherit cmake dot-a unpacker

DESCRIPTION="Qt library and IM module for fcitx5"
HOMEPAGE="https://github.com/fcitx/fcitx5-qt"
SRC_URI="https://download.fcitx-im.org/fcitx5/${MY_PN}/${MY_PN}-${PV}.tar.zst -> ${P}.tar.zst"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="BSD LGPL-2.1+"
SLOT="5"
KEYWORDS="amd64 ~arm64 ~loong ~riscv x86"
IUSE="onlyplugin staticplugin wayland +X"
REQUIRED_USE="
	staticplugin? ( onlyplugin )
"

RDEPEND="
	!onlyplugin? ( >=app-i18n/fcitx-5.1.13:5 )
	dev-qt/qtbase:6=[dbus,gui,widgets,wayland?]
	wayland? ( dev-qt/qtwayland:6 )
	X? (
		x11-libs/libX11
		x11-libs/libxcb
		x11-libs/libxkbcommon
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	kde-frameworks/extra-cmake-modules:0
	virtual/pkgconfig
	!onlyplugin? ( sys-devel/gettext )
"

src_configure() {
	use staticplugin && lto-guarantee-fat
	local mycmakeargs=(
		-DENABLE_QT4=no
		-DENABLE_QT5=no
		-DENABLE_QT6=yes
		-DENABLE_QT6_WAYLAND_WORKAROUND=$(usex wayland)
		-DENABLE_X11=$(usex X)
		-DBUILD_ONLY_PLUGIN=$(usex onlyplugin)
		-DBUILD_STATIC_PLUGIN=$(usex staticplugin)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	use staticplugin && strip-lto-bytecode
}
