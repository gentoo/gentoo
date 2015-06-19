# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/libghemical/libghemical-3.0.0.ebuild,v 1.1 2013/02/02 05:55:29 patrick Exp $

EAPI="3"

inherit autotools eutils

DESCRIPTION="Chemical quantum mechanics and molecular mechanics"
HOMEPAGE="http://bioinformatics.org/ghemical/"
SRC_URI="http://www.bioinformatics.org/ghemical/download/current/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
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
	epatch "${FILESDIR}"/${PN}-2.98-gl.patch
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
