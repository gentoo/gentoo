# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs

MY_P="${PN}.${PV}.src"

DESCRIPTION="Adds hydrogens to a Protein Data Bank (PDB) molecule structure file"
HOMEPAGE="http://kinemage.biochem.duke.edu/software/reduce.php"
SRC_URI="http://kinemage.biochem.duke.edu/downloads/software/reduce31/${MY_P}.zip"

LICENSE="richardson"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	app-arch/unzip"

S="${WORKDIR}/"
PATCHES=(
	"${FILESDIR}"/3.13.080428-LDFLAGS.patch
	"${FILESDIR}"/3.14.080821-CFLAGS.patch
	"${FILESDIR}"/${PN}-3.16.111118-fix-c++14.patch
)

src_compile() {
	DICT_DIR="/usr/share/reduce"
	DICT_FOLD="reduce_het_dict.txt"
	DICT_FNEW="reduce_wwPDB_het_dict.txt"

	emake clean
	emake \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" \
		OPT="${CXXFLAGS}" \
		DICT_HOME="${EPREFIX}/${DICT_DIR}/${DICT_FNEW}" \
		DICT_OLD="${EPREFIX}/${DICT_DIR}/${DICT_FOLD}"
}

src_install() {
	dobin "${S}"/reduce_src/reduce
	insinto ${DICT_DIR}
	doins "${S}"/${DICT_FOLD} "${S}"/${DICT_FNEW}
	dodoc README.usingReduce.txt
}
