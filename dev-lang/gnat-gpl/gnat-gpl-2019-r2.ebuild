# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PATCH_GCC_VER=8.3.0
PATCH_VER="4"

TOOLCHAIN_GCC_PV=8.3.1

REL=8
MYP=gcc-${REL}-${PV}-20190517-18C94-src
GNATDIR=gnat-${PV}-20190517-18C94-src
INTFDIR=gcc-interface-${REL}-${PV}-20190510-18F59-src
BTSTRP_X86=gnat-gpl-2014-x86-linux-bin
BTSTRP_AMD64=gnat-gpl-2014-x86_64-linux-bin

# we provide own tarball below
GCC_TARBALL_SRC_URI="
	http://mirrors.cdn.adacore.com/art/5cdf865331e87aa2cdf16b49
		-> ${GNATDIR}.tar.gz
	http://mirrors.cdn.adacore.com/art/5cdf8a0731e87a8f1d425049
		-> ${MYP}.tar.gz
	http://mirrors.cdn.adacore.com/art/5cdf87cc31e87aa2cdf16b50
		-> ${INTFDIR}.tar.gz
	bootstrap? (
		amd64? (
			http://mirrors.cdn.adacore.com/art/564b3ebec8e196b040fbe66c ->
			${BTSTRP_AMD64}.tar.gz
		)
		x86? (
			http://mirrors.cdn.adacore.com/art/564b3e9dc8e196b040fbe248 ->
			${BTSTRP_X86}.tar.gz
		)
	)"

inherit toolchain-funcs toolchain

DESCRIPTION="GNAT Ada Compiler - GPL version"
HOMEPAGE="http://libre.adacore.com/"

LICENSE+=" GPL-2 GPL-3"
KEYWORDS="amd64 ~x86"
IUSE="+ada +bootstrap"
RESTRICT="test"

RDEPEND="!sys-devel/gcc:${TOOLCHAIN_GCC_PV}"
DEPEND="${RDEPEND}
	elibc_glibc? ( >=sys-libs/glibc-2.13 )
	>=sys-devel/binutils-2.20"

S="${WORKDIR}"/${MYP}
PDEPEND="${PDEPEND} elibc_glibc? ( >=sys-libs/glibc-2.13 )"

pkg_setup() {
	toolchain_pkg_setup

	if use amd64; then
		BTSTRP=${BTSTRP_AMD64}
	else
		BTSTRP=${BTSTRP_X86}
	fi

	if use bootstrap; then
		GCC="${WORKDIR}"/${BTSTRP}/bin/gcc
	else
		GCC=${ADA:-$(tc-getCC)}
	fi

	gnatbase=$(basename ${GCC})
	gnatpath=$(dirname ${GCC})

	GNATMAKE=${gnatbase/gcc/gnatmake}
	if [[ ${gnatpath} != "." ]] ; then
		GNATMAKE="${gnatpath}/${GNATMAKE}"
	fi
}

src_unpack() {
	if ! use bootstrap && [[ -z "$(type ${GNATMAKE} 2>/dev/null)" ]] ; then
		eerror "You need a gcc compiler that provides the Ada Compiler:"
		eerror "1) use gcc-config to select the right compiler or"
		eerror "2) set the bootstrap use flag"
		die "ada compiler not available"
	fi

	toolchain_src_unpack
	if use bootstrap; then
		rm ${BTSTRP}/libexec/gcc/*/4.7.4/ld || die
	fi
}

src_prepare() {
	CC=${GCC}
	CXX="${gnatbase/gcc/g++}"
	GNATBIND="${gnatbase/gcc/gnatbind}"
	GNATLINK="${gnatbase/gcc/gnatlink}"
	GNATLS="${gnatbase/gcc/gnatls}"
	if [[ ${gnatpath} != "." ]] ; then
		CXX="${gnatpath}/${CXX}"
		GNATBIND="${gnatpath}/${GNATBIND}"
		GNATLINK="${gnatpath}/${GNATLINK}"
		GNATLS="${gnatpath}/${GNATLS}"
	fi
	mkdir bin || die
	ln -s $(which ${GCC}) bin/gcc || die
	ln -s $(which ${CXX}) bin/g++ || die
	ln -s $(which ${GNATMAKE}) bin/gnatmake || die
	ln -s $(which ${GNATBIND}) bin/gnatbind || die
	ln -s $(which ${GNATLINK}) bin/gnatlink || die
	ln -s $(which ${GNATLS}) bin/gnatls || die

	cd ..
	mv ${GNATDIR}/src/ada ${MYP}/gcc/ || die
	mv ${INTFDIR} ${MYP}/gcc/ada/gcc-interface || die
	eapply "${FILESDIR}"/${P}-gentoo.patch
	rm patch/27*.patch || die
	rm patch/28*.patch || die
	cd -
	sed -i \
		-e 's:$(P) ::g' \
		gcc/ada/gcc-interface/Makefile.in \
		|| die "sed failed"
	toolchain_src_prepare
}

src_configure() {
	export PATH=${PWD}/bin:${PATH}
	downgrade_arch_flags "$(gcc-version)"
	toolchain_src_configure
}

pkg_postinst() {
	toolchain_pkg_postinst
	einfo "This provide the GNAT compiler with gcc for ada/c/c++ and more"
	einfo "The compiler binary is ${CTARGET}-gcc-${TOOLCHAIN_GCC_PV}"
	einfo "Even if the c/c++ compilers are using almost the same patched"
	einfo "source as the sys-devel/gcc package its use is not extensively"
	einfo "tested, and not supported for updating your system, except for ada"
	einfo "related packages"
}
