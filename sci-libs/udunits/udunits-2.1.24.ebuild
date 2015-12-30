# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils fortran-2 autotools

DESCRIPTION="Library for manipulating units of physical quantities"
HOMEPAGE="https://www.unidata.ucar.edu/software/udunits/"
SRC_URI="ftp://ftp.unidata.ucar.edu/pub/udunits/${P}.tar.gz"

SLOT="0"
LICENSE="UCAR-Unidata"
IUSE="doc static-libs"
KEYWORDS="~alpha ~amd64 ~hppa ~mips ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux"

RDEPEND="dev-libs/expat"
DEPEND="${RDEPEND}"

src_prepare() {
	# respect user's flags, compile with system libexpat
	epatch "${FILESDIR}"/${PN}-2.1.15-autotools.patch
	rm -rf expat
	eautoreconf
}

src_configure() {
	econf \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		$(use_enable static-libs static)
}

src_install() {
	default
	dodoc CHANGE_LOG ANNOUNCEMENT
	doinfo udunits2.info prog/udunits2prog.info
	if use doc; then
		insinto /usr/share/doc/${PF}
		doins udunits2.html udunits2.pdf
		doins prog/udunits2prog.html prog/udunits2prog.pdf
	fi
}
