# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Convert atom names for amino acids/nucleic acid bases between PDB and CNS format"
HOMEPAGE="http://www.mybiosoftware.com/3d-molecular-model/314/"
#SRC_URI="http://kinemage.biochem.duke.edu/php/downlode.php?filename=/downloads/software/scripts/${PN}.${PV}.perl.tgz"
SRC_URI="https://dev.gentoo.org/~jlec/distfiles/${PN}.${PV}.perl.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="dev-lang/perl"

S="${WORKDIR}"/${PN}

src_install() {
	newbin ${PN}*.pl ${PN}

	docinto html
	dodoc *html
}
