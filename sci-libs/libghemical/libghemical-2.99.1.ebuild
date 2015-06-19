# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/libghemical/libghemical-2.99.1.ebuild,v 1.6 2012/05/21 23:25:19 vapier Exp $

EAPI="3"

inherit autotools eutils

DESCRIPTION="Chemical quantum mechanics and molecular mechanics"
HOMEPAGE="http://bioinformatics.org/ghemical/"
SRC_URI="http://www.bioinformatics.org/ghemical/download/current/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="mopac7 mpqc static-libs"

RDEPEND="
	mopac7? ( >=sci-chemistry/mopac7-1.13-r1 )
	mpqc? (
		>=sci-chemistry/mpqc-2.3.1-r1
		virtual/blas
		virtual/lapack )"
DEPEND="${RDEPEND}
		virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gl.patch
	eautoreconf
}

src_configure() {
	econf \
		--enable-shared \
		$(use_enable mopac7) \
		$(use_enable mpqc) \
		$(use_enable static-libs static)
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
}
