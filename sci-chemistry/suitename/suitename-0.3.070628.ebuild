# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit toolchain-funcs

MY_P="${PN}.${PV}"

DESCRIPTION="The ROC RNA Ontology Consortium consensus RNA backbone nomenclature and conformer-list development"
HOMEPAGE="http://kinemage.biochem.duke.edu/software/suitename.php"
SRC_URI="http://kinemage.biochem.duke.edu/downloads/software/${PN}/${MY_P}.src.tgz"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="richardson"
IUSE=""

S="${WORKDIR}"/${MY_P}

src_prepare() {
	tc-export CC
	cp Makefile.linux Makefile || die
	sed \
		-e 's:cc:${CC}:g' \
		-e "s:-o:${LDFLAGS} -o:g" \
		-i Makefile || die
}

src_compile() {
	emake CFLAGS="${CFLAGS}"
}

src_install() {
	dobin ${PN}
}
