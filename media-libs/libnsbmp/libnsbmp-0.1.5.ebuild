# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NETSURF_BUILDSYSTEM=buildsystem-1.7
inherit netsurf

DESCRIPTION="decoding library for BMP and ICO image file formats, written in C"
HOMEPAGE="http://www.netsurf-browser.org/projects/libnsbmp/"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~ppc ~m68k-mint"
IUSE=""

RDEPEND=""
DEPEND="virtual/pkgconfig"

src_prepare() {
	# working around broken netsurf eclass
	default
	multilib_copy_sources
}
