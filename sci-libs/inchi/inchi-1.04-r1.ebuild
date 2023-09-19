# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Program and library for generating standard and non-standard InChI and InChIKeys"
HOMEPAGE="http://www.iupac.org/inchi/"
SRC_URI="
	http://www.inchi-trust.org/sites/default/files/inchi-${PV}/INCHI-1-API.ZIP -> ${P}.zip
	doc? ( http://www.inchi-trust.org/sites/default/files/inchi-${PV}/INCHI-1-DOC.ZIP -> ${P}-doc.zip )"
S="${WORKDIR}"/INCHI-1-API

LICENSE="IUPAC-InChi"
SLOT="0"
KEYWORDS="amd64 arm ~ppc ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc"

BDEPEND="app-arch/unzip"

PATCHES=(
	"${FILESDIR}"/${PN}-1.03-shared.patch
)

src_configure() {
	tc-export AR RANLIB
}

src_compile() {
	local dir common_opts
	common_opts=(
			C_COMPILER=$(tc-getCC)
			CPP_COMPILER=$(tc-getCXX)
			LINKER="$(tc-getCXX) ${LDFLAGS}"
			SHARED_LINK="$(tc-getCC) ${LDFLAGS} -shared"
			C_COMPILER_OPTIONS="\${P_INCL} -ansi -DCOMPILE_ANSI_ONLY ${CFLAGS} -c "
			CPP_COMPILER_OPTIONS="\${P_INCL} -D_LIB -ansi ${CXXFLAGS} -frtti -c "
			C_OPTIONS="${CFLAGS} -fPIC -c "
			LINKER_OPTIONS="${LDFLAGS}"
			CREATE_MAIN=
			ISLINUX=1
	)
	for dir in  INCHI/gcc/inchi-1 INCHI_API/gcc_so_makefile; do
		pushd ${dir} > /dev/null || die
		emake \
			"${common_opts[@]}"
		popd > /dev/null || die
	done
}

src_install() {
	dodoc readme*.txt
	if use doc ; then
		cd "${WORKDIR}"/INCHI-1-DOC || die
		docinto doc
		dodoc *.pdf readme.txt
	fi
	dobin "${S}"/INCHI/gcc/inchi-1/inchi-1
	cd "${S}"/INCHI_API/gcc_so_makefile/result || die
	rm *gz || die
	dolib.so lib*so*
	doheader ../../inchi_main/inchi_api.h
}
