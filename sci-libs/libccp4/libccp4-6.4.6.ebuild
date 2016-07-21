# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

FORTRAN_NEEDED=fortran

inherit autotools-utils fortran-2

DESCRIPTION="The CCP4 C and F77 subroutine library"
HOMEPAGE="http://www.ccp4.ac.uk/"
SRC_URI="ftp://ftp.ccp4.ac.uk/opensource/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-3 LGPL-3"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="fortran static-libs"

RDEPEND="sci-libs/mmdb:2"
DEPEND="${RDEPEND}
"
AUTOTOOLS_IN_SOURCE_BUILD=1

src_configure() {
	myeconfargs=(
		$(use_enable fortran)
	)
	autotools-utils_src_configure
}
