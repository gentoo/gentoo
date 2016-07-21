# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
inherit toolchain-funcs

MY_P="${PN}_${PV}"
DESCRIPTION="Interconverts between various bibliography formats using a common XML intermediate"
HOMEPAGE="http://www.scripps.edu/~cdputnam/software/bibutils/"
SRC_URI="http://www.scripps.edu/~cdputnam/software/bibutils/${MY_P}_src.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

S=${WORKDIR}/${MY_P}

src_prepare() {
	# The custom configure script sucks, so we'll just do its
	# job ourselves
	rm -f Makefile configure || die "Failed to purge old Makefile"
	sed \
		-e "s:REPLACE_CC:CC=\"$(tc-getCC) ${CFLAGS}\":g" \
		-e "s:REPLACE_RANLIB:RANLIB=\"$(tc-getRANLIB)\":g" \
		-e "s:REPLACE_INSTALLDIR:\"${D}/usr/bin\":g" \
		-e 's:REPLACE_POSTFIX::g' \
		-e 's:make:$(MAKE):g' \
		Makefile_start > Makefile \
		|| die "Failed to set up Makefile"
}

src_install() {
	dodir /usr/bin
	emake install || die
	dodoc ChangeLog || die
}
