# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

FORTRAN_NEEDED="fortran"

inherit fortran-2 multilib

DESCRIPTION="Library to read gromacs trajectory and topology files"
HOMEPAGE="http://www.gromacs.org/Developer_Zone/Programming_Guide/XTC_Library"
SRC_URI="ftp://ftp.gromacs.org/pub/contrib/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="fortran static-libs"

src_configure() {
	local myeconfargs=( $(use_enable fortran) )

	default
}
