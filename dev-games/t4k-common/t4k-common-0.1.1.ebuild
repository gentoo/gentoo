# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils

DESCRIPTION="A library of code shared between tuxmath and tuxtype"
HOMEPAGE="https://github.com/tux4kids/t4kcommon"
SRC_URI="https://github.com/tux4kids/t4kcommon/archive/upstream/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="static-libs svg"

RDEPEND="dev-libs/libxml2:2
	media-libs/libsdl
	media-libs/sdl-image
	media-libs/sdl-mixer
	media-libs/sdl-net
	media-libs/sdl-ttf
	media-libs/sdl-pango
	svg? (
		gnome-base/librsvg:2
		media-libs/libpng:0
		x11-libs/cairo
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/t4kcommon-upstream-${PV}

src_prepare() {
	epatch "${FILESDIR}"/${P}-libpng.patch
}

src_configure() {
	econf \
		$(usex svg "" "--without-rsvg") \
		$(use_enable static-libs static)
}

src_install() {
	default
	use static-libs || prune_libtool_files --all
}
