# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Input method development support for xcb"
HOMEPAGE="https://github.com/fcitx/xcb-imdkit"
SRC_URI="https://download.fcitx-im.org/fcitx5/${PN}/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="5"
KEYWORDS="~amd64 ~loong ~x86"

RDEPEND="
	x11-libs/libxcb
	x11-libs/xcb-util
	x11-libs/xcb-util-keysyms
"
DEPEND="
	${RDEPEND}
	dev-libs/uthash
"
BDEPEND="
	kde-frameworks/extra-cmake-modules:0
	virtual/pkgconfig
"

src_configure() {
	local mycmakeargs=(
		-DUSE_SYSTEM_UTHASH=ON
	)
	cmake_src_configure
}
