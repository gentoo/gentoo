# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Library of cd audio related routines"
HOMEPAGE="https://libcdaudio.sourceforge.net/"
SRC_URI="mirror://sourceforge/libcdaudio/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"

PATCHES=(
	"${FILESDIR}"/${PN}-0.99-CAN-2005-0706.patch
	"${FILESDIR}"/${P}-bug245649.patch
	"${FILESDIR}"/${P}-libdir-fix.patch
	"${FILESDIR}"/${P}-m4-testprogram-fix.patch
)

src_prepare() {
	default

	# replace vintage 2004 autotools collection complete with worrying
	# code to "make it portable" by converting ANSI C into K&R C
	sed -i '/AM_C_PROTOTYPES/d' configure.ac
	sed -i '/ansi2knr/d' Makefile.am
	eautoreconf
}

src_configure() {
	econf --enable-threads --disable-static
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
