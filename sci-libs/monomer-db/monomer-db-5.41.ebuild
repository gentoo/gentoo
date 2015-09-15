# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_PN="refmac_dictionary"

DESCRIPTION="Monomer library used for macromolecular structure building and refinement"
HOMEPAGE="http://www2.mrc-lmb.cam.ac.uk/groups/murshudov/"
SRC_URI="http://www2.mrc-lmb.cam.ac.uk/groups/murshudov/content/refmac/Dictionary/${MY_PN}_v${PV}.tar.gz"

SLOT="0"
LICENSE="LGPL-3"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE=""

RESTRICT="binchecks strip"

S="${WORKDIR}"/monomers

src_install() {
	insinto /usr/share/data/monomers/
	for i in {a..z} {0..9} *list *.cif *.txt *table *pdb; do
		einfo "Installing ${i}** ..."
		doins -r ${i}
	done
	dodoc *.txt
}
