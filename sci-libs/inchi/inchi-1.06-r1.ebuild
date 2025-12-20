# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Program and library for generating standard and non-standard InChI and InChIKeys"
HOMEPAGE="https://www.iupac.org/inchi/"
SRC_URI="
	https://www.inchi-trust.org/download/${PV//.}/INCHI-1-SRC.zip -> ${P}.zip
	doc? ( https://www.inchi-trust.org/download/${PV//.}/INCHI-1-DOC.zip -> ${P}-doc.zip )
"
S="${WORKDIR}/INCHI-1-SRC"

LICENSE="IUPAC-InChi"
SLOT="0"
KEYWORDS="amd64 arm ~ppc ppc64 ~x86"
IUSE="doc"

BDEPEND="app-arch/unzip"

src_compile() {
	local common_opts target_opts

	append-cflags \${P_INCL} -ansi -DCOMPILE_ANSI_ONLY -fPIC -c
	append-cxxflags \${P_INCL} -ansi -frtti -c

	common_opts=(
			C_COMPILER="$(tc-getCC)"
			CPP_COMPILER="$(tc-getCXX)"
			AR="$(tc-getAR)"
			RANLIB="$(tc-getRANLIB)"
			LINKER="$(tc-getCXX)"
			SHARED_LINK="$(tc-getCC)"
			SHARED_LINK_PARM="${LDFLAGS} -shared "
			ISLINUX=1
	)

	# Compile the library
	target_opts=(
		LINKER_OPTIONS="${LDFLAGS} "
		C_OPTIONS="${CFLAGS} -DTARGET_API_LIB -D_LIB -D_XOPEN_SOURCE=500 " #874696
		CPP_OPTIONS="${CXXFLAGS} -DTARGET_API_LIB  -D_LIB "
		CREATE_MAIN=
	)
	emake -C INCHI_API/libinchi/gcc "${common_opts[@]}" "${target_opts[@]}"

	pushd "INCHI_API/bin/Linux" || die
	ln -s libinchi.so.1 libinchi.so || die
	popd > /dev/null || die

	# Compile the executable
	target_opts=(
		LINKER_OPTIONS="${LDFLAGS} -L${S}/INCHI_API/bin/Linux -linchi "
		C_COMPILER_OPTIONS="${CFLAGS} -DTARGET_EXE_STANDALONE "
		CPP_COMPILER_OPTIONS="${CXXFLAGS}  -DTARGET_EXE_STANDALONE "
		CREATE_MAIN=
	)
	emake -C INCHI_EXE/inchi-1/gcc "${common_opts[@]}" "${target_opts[@]}"

}

src_install() {
	dodoc readme*.txt
	if use doc ; then
		pushd "${WORKDIR}/INCHI-1-DOC" || die
		docinto doc
		dodoc *.pdf readme.txt
		popd || die
	fi
	dobin "${S}/INCHI_EXE/bin/Linux/inchi-1"
	dolib.so "${S}/INCHI_API/bin/Linux/"lib*so*
	doheader "${S}/INCHI_BASE/src/"{inchi_api,ixa}.h
}
