# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PATCH_GCC_VER=9.3.0
PATCH_VER="5"

TOOLCHAIN_GCC_PV=9.3.1

REL=9
MYP=gcc-${REL}-${PV}-20200429-19AA7-src
GNATDIR=gnat-${PV}-20200429-19B04-src
INTFDIR=gcc-interface-${REL}-${PV}-20200429-19B10-src
BTSTRP_X86=gnat-gpl-2014-x86-linux-bin
BTSTRP_AMD64=gnat-gpl-2014-x86_64-linux-bin

# we provide own tarball below
GCC_TARBALL_SRC_URI="
	https://community.download.adacore.com/v1/649a561ec6de9e476c54b02715b79f7503600ce5?filename=${GNATDIR}.tar.gz
		-> ${GNATDIR}.tar.gz
	https://community.download.adacore.com/v1/e6b6a3e318e13248456bd37b758435e602b367da?filename=${MYP}.tar.gz
		-> ${MYP}.tar.gz
	https://community.download.adacore.com/v1/c7a97636b31f3575df85f1eb0965462a353630dd?filename=${INTFDIR}.tar.gz
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
KEYWORDS="amd64 x86"
IUSE="+ada +bootstrap"
RESTRICT="test"

RDEPEND="!sys-devel/gcc:${TOOLCHAIN_GCC_PV}"
DEPEND="${RDEPEND}
	elibc_glibc? ( >=sys-libs/glibc-2.13 )
	>=sys-devel/binutils-2.20"

S="${WORKDIR}"/${MYP}
PDEPEND="${PDEPEND} elibc_glibc? ( >=sys-libs/glibc-2.13 )"

src_unpack() {
	if ! use bootstrap && [[ -z "$(type ${GNATMAKE} 2>/dev/null)" ]] ; then
		eerror "You need a gcc compiler that provides the Ada Compiler:"
		eerror "1) use gcc-config to select the right compiler or"
		eerror "2) set the bootstrap use flag"
		die "ada compiler not available"
	fi

	toolchain_src_unpack
}

src_prepare() {
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
	if use bootstrap; then
		rm "${WORKDIR}"/${BTSTRP}/libexec/gcc/x86_64-pc-linux-gnu/4.7.4/ld \
			|| die
		ln -s /usr/bin/$CHOST-ld \
			"${WORKDIR}"/${BTSTRP}/libexec/gcc/x86_64-pc-linux-gnu/4.7.4/ld \
			|| die
	fi

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
	ln -s $(type -P ${GCC}) bin/gcc || die
	ln -s $(type -P ${CXX}) bin/g++ || die
	ln -s $(type -P ${GNATMAKE}) bin/gnatmake || die
	ln -s $(type -P ${GNATBIND}) bin/gnatbind || die
	ln -s $(type -P ${GNATLINK}) bin/gnatlink || die
	ln -s $(type -P ${GNATLS}) bin/gnatls || die

	cd ..
	mv ${GNATDIR}/src/ada ${MYP}/gcc/ || die
	mv ${INTFDIR} ${MYP}/gcc/ada/gcc-interface || die
	eapply "${FILESDIR}"/${P}-gentoo.patch
	rm patch/32*.patch || die
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
