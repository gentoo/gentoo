# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/libghemical/libghemical-2.00.ebuild,v 1.6 2012/05/04 08:22:49 jdhore Exp $

inherit autotools eutils

DESCRIPTION="Chemical quantum mechanics and molecular mechanics"
HOMEPAGE="http://bioinformatics.org/ghemical/"
SRC_URI="http://www.bioinformatics.org/ghemical/download/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE="mopac7 mpqc"
RDEPEND="mopac7? ( sci-chemistry/mopac7 )
		mpqc? ( >=sci-chemistry/mpqc-2.3.1-r1
			virtual/blas
			virtual/lapack )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}"/${PV}-really-find-blas-and-lapack.patch
	cd "${S}"
	eautoreconf
}

src_compile() {
	econf \
		$(use_enable mopac7) \
		$(use_enable mpqc) \
		|| die "configure failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
}
