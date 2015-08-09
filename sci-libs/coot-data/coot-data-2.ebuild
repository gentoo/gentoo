# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

DESCRIPTION="Data for the Crystallographic Object-Oriented Toolkit"
HOMEPAGE="http://www.biop.ox.ac.uk/coot/"
#SRC_URI="http://www.ysbl.york.ac.uk/~emsley/software/extras/reference-structures.tar.gz"
SRC_URI="mirror://gentoo/reference-structures-${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE=""

RESTRICT="binchecks strip"

S="${WORKDIR}"

src_install() {
	insinto /usr/share/coot
	doins -r reference-structures || die

	# Coot looks in the wrong spot for the monomer library
	# Listens to ccp4's CCP4_LIB rather than CLIBD_MON
	cat >> "${T}"/coot <<- EOF
	COOT_REFMAC_LIB_DIR="${EPREFIX}/usr/share/ccp4/"
	COOT_REF_STRUCTS="${EPREFIX}/usr/share/coot/reference-structures/"
	EOF

	newenvd "${T}"/coot 20coot || die
}
