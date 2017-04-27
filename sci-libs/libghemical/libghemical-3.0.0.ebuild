# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Chemical quantum mechanics and molecular mechanics"
HOMEPAGE="http://bioinformatics.org/ghemical/"
SRC_URI="http://www.bioinformatics.org/ghemical/download/current/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="mopac7 mpqc static-libs"

RDEPEND="
	mopac7? ( >=sci-chemistry/mopac7-1.13-r1 )
	mpqc? (
		>=sci-chemistry/mpqc-2.3.1-r1
		virtual/blas
		virtual/lapack
	)"
DEPEND="${RDEPEND}
		virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${PN}-2.98-gl.patch )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--enable-shared \
		$(use_enable mopac7) \
		$(use_enable mpqc) \
		$(use_enable static-libs static)
}
