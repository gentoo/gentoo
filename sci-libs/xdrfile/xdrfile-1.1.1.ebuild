# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/xdrfile/xdrfile-1.1.1.ebuild,v 1.2 2013/12/01 20:40:05 ottxor Exp $

EAPI=5

FORTRAN_NEEDED="fortran"

inherit autotools-multilib fortran-2

DESCRIPTION="Library to read gromacs trajectory and topology files"
HOMEPAGE="http://www.gromacs.org/Developer_Zone/Programming_Guide/XTC_Library"
SRC_URI="ftp://ftp.gromacs.org/pub/contrib/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="fortran static-libs"

src_configure() {
	local myeconfargs=( $(use_enable fortran) )

	autotools-multilib_src_configure
}
