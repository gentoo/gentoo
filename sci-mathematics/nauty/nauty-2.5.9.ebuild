# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/nauty/nauty-2.5.9.ebuild,v 1.3 2015/04/21 17:40:59 pacho Exp $

EAPI=5

inherit versionator

MY_PV=$(replace_version_separator 2 'r')
MY_PV=$(delete_version_separator 1 ${MY_PV})

DESCRIPTION="Computing automorphism groups of graphs and digraphs"
HOMEPAGE="http://pallini.di.uniroma1.it/"
SRC_URI="http://cs.anu.edu.au/~bdm/${PN}/${PN}${MY_PV}.tar.gz"

LICENSE="nauty"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

S="${WORKDIR}/${PN}${MY_PV}"

src_prepare () {
	sed \
		-e "s/^LDFLAGS=.*/LDFLAGS=${LDFLAGS}/" \
		-e 's:${CC} -o:${CC} ${LDFLAGS} -o:g' \
		-e 's:${LDFLAGS}$::g' \
		-i makefile.in || die
}

src_test () {
	emake checks
	./runalltests
}

src_install () {
	dobin addedgeg amtog biplabg catg complg copyg countg \
		deledgeg directg dreadnaut dretog genbg geng genrang \
		gentourng labelg listg multig newedgeg NRswitchg pickg \
		planarg shortg showg
	dodoc README formats.txt nug*.pdf
}
