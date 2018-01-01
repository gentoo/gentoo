# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

NETSURF_BUILDSYSTEM=buildsystem-1.6
inherit netsurf

DESCRIPTION="decoding library for the GIF image file format, written in C"
HOMEPAGE="http://www.netsurf-browser.org/projects/libnsgif/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~m68k-mint"
IUSE=""

RDEPEND=""
DEPEND="virtual/pkgconfig"

src_prepare() {
	sed -e '1i#pragma GCC diagnostic ignored "-Wimplicit-fallthrough"' \
		-i src/lzw.c || die

	netsurf_src_prepare
}
