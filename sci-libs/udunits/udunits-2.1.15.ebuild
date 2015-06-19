# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/udunits/udunits-2.1.15.ebuild,v 1.9 2012/10/16 19:34:33 jlec Exp $

EAPI=2

inherit eutils fortran-2 autotools

DESCRIPTION="Library for manipulating units of physical quantities"
HOMEPAGE="http://www.unidata.ucar.edu/packages/udunits/"
SRC_URI="ftp://ftp.unidata.ucar.edu/pub/udunits/${P}.tar.gz"

SLOT="0"
LICENSE="UCAR-Unidata"
IUSE="doc"
KEYWORDS="alpha amd64 ~hppa ~mips ppc ~sparc x86"

RDEPEND="dev-libs/expat"
DEPEND="${RDEPEND}"

src_prepare() {
	# respect user's flags, compile with system libexpat
	epatch "${FILESDIR}"/${P}-autotools.patch
	rm -rf expat
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc CHANGE_LOG ANNOUNCEMENT
	doinfo udunits2.info prog/udunits2prog.info
	if use doc; then
		insinto /usr/share/doc/${PF}
		doins udunits2.html udunits2.pdf
		doins prog/udunits2prog.html prog/udunits2prog.pdf
	fi
}
