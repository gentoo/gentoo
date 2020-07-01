# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake

DESCRIPTION="Window Manager From Scratch, A tiling window manager highly configurable"
HOMEPAGE="https://github.com/xorg62/wmfs"
SRC_URI="https://github.com/xorg62/wmfs/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	media-libs/freetype
	media-libs/imlib2[X]
	x11-libs/libX11
	x11-libs/libXft
	x11-libs/libXinerama
	x11-libs/libXrandr
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	x11-base/xorg-proto
"

PATCHES=(
	"${FILESDIR}"/${PN}-201003-desktop.patch
	"${FILESDIR}"/${PN}-201003-pthread.patch
)

src_prepare() {
	cmake_src_prepare
	sed -i \
		-e '/set(CFLAGS/d' \
		-e '/set(LDFLAGS/s#)# ${LDFLAGS}&#' \
		CMakeLists.txt || die
}

src_install() {
	cmake_src_install
	rm -r "${D}"/usr/share/${PN}
	find "${D}"/usr/share/man -name '*.gz' -exec gunzip {} \; || die
	dodoc README TODO rc/status.sh
}
