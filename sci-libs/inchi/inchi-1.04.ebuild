# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="Program and library for generating standard and non-standard InChI and InChIKeys"
HOMEPAGE="http://www.iupac.org/inchi/"
SRC_URI="
	http://www.inchi-trust.org/sites/default/files/inchi-${PV}/INCHI-1-API.ZIP -> ${P}.zip
	doc? ( http://www.inchi-trust.org/sites/default/files/inchi-${PV}/INCHI-1-DOC.ZIP -> ${P}-doc.zip )"

LICENSE="IUPAC-InChi"
SLOT="0"
KEYWORDS="amd64 arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="doc static-libs"

DEPEND="app-arch/unzip"
RDEPEND=""

S="${WORKDIR}"/INCHI-1-API

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-1.03-shared.patch \
		"${FILESDIR}"/${PN}-1.04-static.patch
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
		pushd ${dir} > /dev/null
		emake \
			"${common_opts[@]}"
		popd > /dev/null
	done
	if use static-libs ; then
		pushd INCHI_API/gcc_so_makefile > /dev/null
		emake libinchi.a \
				"${common_opts[@]}" \
				STATIC=1
		popd > /dev/null
	fi
}

src_install() {
	dodoc readme*.txt
	if use doc ; then
		cd "${WORKDIR}/INCHI-1-DOC/"
		docinto doc
		dodoc *.pdf readme.txt
	fi
	dobin "${S}"/INCHI/gcc/inchi-1/inchi-1
	cd "${S}/INCHI_API/gcc_so_makefile/result" || die
	rm *gz || die
	dolib.so lib*so*
	use static-libs && dolib.a lib*a
	doheader ../../inchi_main/inchi_api.h
}
