# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Gesture/Handwriting recognition engine for X"
HOMEPAGE="http://freshmeat.net/projects/xstroke/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha ~amd64 hppa ~mips ppc sparc x86"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXft
	x11-libs/libXpm
	x11-libs/libXrender
	x11-libs/libXtst"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="
	sys-devel/flex
	virtual/pkgconfig
	virtual/yacc"

PATCHES=(
	"${FILESDIR}"/${P}-sigsegv_sprintf.patch
	"${FILESDIR}"/${P}-underlinking.patch
)

src_prepare() {
	default
	eautoreconf
}
