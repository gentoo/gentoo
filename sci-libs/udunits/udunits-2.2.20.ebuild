# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit fortran-2

DESCRIPTION="Library for manipulating units of physical quantities"
HOMEPAGE="https://www.unidata.ucar.edu/software/udunits/"
SRC_URI="ftp://ftp.unidata.ucar.edu/pub/udunits/${P}.tar.gz"

SLOT="0"
LICENSE="UCAR-Unidata"
KEYWORDS="~alpha ~amd64 ~hppa ~mips ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

RDEPEND="dev-libs/expat"
DEPEND="${RDEPEND}"

src_configure() {
	econf \
		$(use_enable static-libs static)
}

src_install() {
	default
	doinfo udunits2.info prog/udunits2prog.info
	dodoc CHANGE_LOG ANNOUNCEMENT
	dodoc udunits2.pdf prog/udunits2prog.pdf
	docinto html
	dodoc udunits2.html prog/udunits2prog.html
}
