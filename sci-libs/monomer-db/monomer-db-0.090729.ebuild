# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Monomer library used for macromolecular structure building and refinement"
HOMEPAGE="http://www.ccp4.ac.uk/"
# SRC_URI="http://www.ysbl.york.ac.uk/~garib/refmac/data/refmac_dictionary.tar.gz"
SRC_URI="https://dev.gentoo.org/~jlec/science-dist/${P}.tar.gz"

LICENSE="ccp4"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="!<sci-chemistry/ccp4-6.1.3"
DEPEND="${RDEPEND}"

RESTRICT="binchecks strip"

S="${WORKDIR}"/dic

src_install() {
	insinto /usr/share/ccp4/data/monomers/
	for i in {a..z} {1..9} *list *.cif *.txt; do
		doins -r ${i}
	done
	docinto html
	dodoc *.html
}
