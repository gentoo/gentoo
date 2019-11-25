# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PATCH_VER="1.4"
UCLIBC_VER="1.0"

# Hardened gcc 4 stuff
PIE_VER="0.6.4"
SPECS_VER="0.2.0"
SPECS_GCC_VER="4.4.3"
# arch/libc configurations known to be stable with {PIE,SSP}-by-default
PIE_GLIBC_STABLE="x86 amd64 mips ppc ppc64 arm ia64"
PIE_UCLIBC_STABLE="x86 arm amd64 mips ppc ppc64"
SSP_STABLE="amd64 x86 mips ppc ppc64 arm"
# uclibc need tls and nptl support for SSP support
# uclibc need to be >= 0.9.33
SSP_UCLIBC_STABLE="x86 amd64 mips ppc ppc64 arm"
#end Hardened stuff

TOOLCHAIN_GCC_PV=4.9.4

inherit toolchain-funcs toolchain

REL=4.9
MYP=gcc-${REL}-gpl-${PV}-src
BTSTRP_X86=gnat-gpl-2014-x86-linux-bin
BTSTRP_AMD64=gnat-gpl-2014-x86_64-linux-bin

DESCRIPTION="GNAT Ada Compiler - GPL version"
HOMEPAGE="http://libre.adacore.com/"
SRC_URI+="
	http://mirrors.cdn.adacore.com/art/57399304c7a447658e0aff7f
		-> ${P}-src.tar.gz
	http://mirrors.cdn.adacore.com/art/573992d4c7a447658d00e1db
		-> ${MYP}.tar.gz
	http://mirrors.cdn.adacore.com/art/57399232c7a447658e0aff7d
		-> gcc-interface-${REL}-gpl-${PV}-src.tar.gz
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

LICENSE+=" GPL-2 GPL-3"
SLOT="${TOOLCHAIN_GCC_PV}"
KEYWORDS="amd64 x86"
IUSE="+bootstrap"

RDEPEND="!sys-devel/gcc:${TOOLCHAIN_GCC_PV}"
DEPEND="${RDEPEND}
	elibc_glibc? ( >=sys-libs/glibc-2.8 )
	>=sys-devel/binutils-2.20"

PDEPEND="${PDEPEND} elibc_glibc? ( >=sys-libs/glibc-2.8 )"

S="${WORKDIR}"/${MYP}

FSFGCC=gcc-${TOOLCHAIN_GCC_PV}

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
	CC=${GCC}
	local base=$(basename ${GCC})
	CXX="${base/gcc/g++}"
	GNATMAKE="${base/gcc/gnatmake}"
	GNATBIND="${base/gcc/gnatbind}"
	if [[ ${base} != ${GCC} ]] ; then
		local path=$(dirname ${GCC})
		GNATMAKE="${path}/${GNATMAKE}"
		GNATBIND="${path}/${GNATBIND}"
		CXX="${path}/${CXX}"
	fi
}

src_unpack() {
	if ! use bootstrap && [[ -z "$(type ${GNATMAKE} 2>/dev/null)" ]] ; then
		eerror "You need a gcc compiler that provides the Ada Compiler:"
		eerror "1) use gcc-config to select the right compiler or"
		eerror "2) set the bootstrap use flag"
		die "ada compiler not available"
	fi

	GCC_A_FAKEIT="${P}-src.tar.gz
		${MYP}.tar.gz
		${FSFGCC}.tar.bz2
		gcc-interface-${REL}-gpl-${PV}-src.tar.gz"
	if use bootstrap; then
		GCC_A_FAKEIT="${GCC_A_FAKEIT} ${BTSTRP}.tar.gz"
	fi

	toolchain_src_unpack
	if use bootstrap; then
		rm ${BTSTRP}/libexec/gcc/${CHOST}/4.7.4/ld || die
	fi
}

src_prepare() {
	cd ..

	sed -i \
		-e "s:gnatmake:${GNATMAKE}:g" \
		${P}-src/src/ada/Make-generated.in || die "sed failed"
	sed -i \
		-e "/xoscons/s:gnatmake:${GNATMAKE}:g" \
		gcc-interface-${REL}-gpl-${PV}-src/Makefile.in || die "sed failed"

	mv ${P}-src/src/ada ${MYP}/gcc/ || die
	mv gcc-interface-${REL}-gpl-${PV}-src ${MYP}/gcc/ada/gcc-interface || die
	mv ${FSFGCC}/gcc/doc/gcc.info ${MYP}/gcc/doc/ || die
	mv ${FSFGCC}/libjava ${MYP} || die
	rm -r ${FSFGCC} || die
	eapply "${FILESDIR}"/${P}-gentoo.patch
	cd -

	# Bug 638056
	eapply "${FILESDIR}/${P}-bootstrap.patch"
	# add Finalization_Size Attribute
	eapply "${FILESDIR}/${P}-finalization.patch"
	# add profile for gnat_util compatibility
	eapply "${FILESDIR}/${P}-profile.patch"

	EPATCH_EXCLUDE+=" 34_all_gcc48_config_i386.patch"
	EPATCH_EXCLUDE+=" 10_all_default-fortify-source.patch"

	toolchain_src_prepare

	use vanilla && return 0
	# Use -r1 for newer piepatchet that use DRIVER_SELF_SPECS for the hardened specs.
	[[ ${CHOST} == ${CTARGET} ]] && eapply "${FILESDIR}"/gcc-spec-env-r1.patch
}

src_configure() {
	local trueGCC_BRANCH_VER=${GCC_BRANCH_VER}
	GCC_BRANCH_VER=$(gcc-version)
	downgrade_arch_flags
	GCC_BRANCH_VER=${trueGCC_BRANCH_VER}
	toolchain_src_configure \
		--enable-languages=ada \
		--disable-libada \
		CC=${GCC} \
		GNATBIND=${GNATBIND} \
		GNATMAKE=yes
}

src_compile() {
	unset ADAFLAGS
	toolchain_src_compile
	gcc_do_make "-C gcc gnatlib-shared"
	ln -s gcc ../build/prev-gcc || die
	ln -s ${CHOST} ../build/prev-${CHOST} || die
	gcc_do_make "-C gcc gnattools"
}

pkg_postinst () {
	toolchain_pkg_postinst
	einfo "This provide the GNAT compiler with gcc for ada/c/c++ and more"
	einfo "The compiler binary is gcc-${TOOLCHAIN_GCC_PV}"
	einfo "Even if the c/c++ compilers are using almost the same patched"
	einfo "source as the sys-devel/gcc package its use is not extensively"
	einfo "tested, and not supported for updating your system, except for ada"
	einfo "related packages"
}
