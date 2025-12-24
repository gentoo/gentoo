# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="fcitx5-qt"

inherit cmake unpacker

DESCRIPTION="Qt library and IM module for fcitx5"
HOMEPAGE="https://github.com/fcitx/fcitx5-qt"
SRC_URI="https://download.fcitx-im.org/fcitx5/${MY_PN}/${MY_PN}-${PV}.tar.zst -> ${P}.tar.zst"

S="${WORKDIR}/${MY_PN}-${PV}"
LICENSE="BSD LGPL-2.1+"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"
IUSE="qt5 onlyplugin staticplugin +qt6 +X wayland"
REQUIRED_USE="
	|| ( qt5 qt6 )
	qt5? ( X )
	staticplugin? ( onlyplugin )
"

RDEPEND="
	!onlyplugin? (
		>=app-i18n/fcitx-5.1.13:5
		qt5? ( dev-qt/qtconcurrent:5 )
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtdbus:5
		dev-qt/qtgui:5=
		dev-qt/qtwidgets:5
		wayland? ( dev-qt/qtwayland:5 )
	)
	qt6? (
		dev-qt/qtbase:6=[dbus,gui,widgets,wayland?]
		wayland? ( dev-qt/qtwayland:6 )
	)
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
	local mycmakeargs=(
		-DENABLE_QT4=no
		-DENABLE_QT5=$(usex qt5)
		-DENABLE_QT6=$(usex qt6)
		-DENABLE_QT6_WAYLAND_WORKAROUND=$(usex qt6 $(usex wayland))
		-DENABLE_X11=$(usex X)
		-DBUILD_ONLY_PLUGIN=$(usex onlyplugin)
		-DBUILD_STATIC_PLUGIN=$(usex staticplugin)
	)
	cmake_src_configure
}
