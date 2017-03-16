# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PATCH_VER="1.0"
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
GCC_FILESDIR=${PORTDIR}/sys-devel/gcc/files

inherit eutils toolchain-funcs toolchain

REL=4.9
MYP=gcc-${REL}-gpl-${PV}-src

DESCRIPTION="GNAT Ada Compiler - GPL version"
HOMEPAGE="http://libre.adacore.com/"
SRC_URI+="
	http://mirrors.cdn.adacore.com/art/57399304c7a447658e0aff7f
		-> ${P}-src.tar.gz
	http://mirrors.cdn.adacore.com/art/573992d4c7a447658d00e1db
		-> ${MYP}.tar.gz
	http://mirrors.cdn.adacore.com/art/57399232c7a447658e0aff7d
		-> gcc-interface-${REL}-gpl-${PV}-src.tar.gz"

LICENSE+=" GPL-2 GPL-3"
SLOT="${TOOLCHAIN_GCC_PV}"
KEYWORDS="~amd64"

RDEPEND="!sys-devel/gcc:${TOOLCHAIN_GCC_PV}"
DEPEND="${RDEPEND}
	elibc_glibc? ( >=sys-libs/glibc-2.8 )
	>=sys-devel/binutils-2.20"

S="${WORKDIR}"/${MYP}

FSFGCC=gcc-${TOOLCHAIN_GCC_PV}

GCC_A_FAKEIT="${P}-src.tar.gz
	${MYP}.tar.gz
	${FSFGCC}.tar.bz2
	gcc-interface-${REL}-gpl-${PV}-src.tar.gz"

pkg_setup() {
	GCC=${ADA:-$(tc-getCC)}
	local base=$(basename ${GCC})
	GNATMAKE="${base/gcc/gnatmake}"
	GNATBIND="${base/gcc/gnatbind}"
	if [[ ${base} != ${GCC} ]] ; then
		local path=$(dirname ${GCC})
		GNATMAKE="${path}/${GNATMAKE}"
		GNATBIND="${path}/${GNATBIND}"
	fi
	if [[ -z "$(type ${GNATMAKE} 2>/dev/null)" ]] ; then
		eerror "You need a gcc compiler that provides the Ada Compiler:"
		eerror "1) use gcc-config to select the right compiler or"
		eerror "2) set the ADA variable to the c/c++/ada compiler"
		die "ada compiler not available"
	fi
}

src_prepare() {
	mv ../gnat-gpl-${PV}-src/src/ada gcc/ || die
	mv ../gcc-interface-${REL}-gpl-${PV}-src gcc/ada/gcc-interface || die

	sed -i \
		-e "s:gnatmake:${GNATMAKE}:g" \
		gcc/ada/Make-generated.in || die "sed failed"

	sed -i \
		-e "/xoscons/s:gnatmake:${GNATMAKE}:g" \
		gcc/ada/gcc-interface/Makefile.in || die "sed failed"

	mv ../${FSFGCC}/gcc/doc/gcc.info gcc/doc/ || die
	mv ../${FSFGCC}/libjava . || die
	rm -r ../${FSFGCC} || die

	cd ..
	epatch "${FILESDIR}"/${P}-gentoo.patch
	rm patch/10_all_default-fortify-source.patch
	rm piepatch/34_all_gcc48_config_i386.patch
	cd -

	if has_version '<sys-libs/glibc-2.12' ; then
		ewarn "Your host glibc is too old; disabling automatic fortify."
		ewarn "Please rebuild gcc after upgrading to >=glibc-2.12 #362315"
		EPATCH_EXCLUDE+=" 10_all_default-fortify-source.patch"
	fi

	toolchain_src_prepare

	use vanilla && return 0
	#Use -r1 for newer piepatchet that use DRIVER_SELF_SPECS for the hardened specs.
	[[ ${CHOST} == ${CTARGET} ]] && epatch "${FILESDIR}"/gcc-spec-env-r1.patch
}

src_configure() {
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
	ln -s x86_64-pc-linux-gnu ../build/prev-x86_64-pc-linux-gnu || die
	gcc_do_make "-C gcc gnattools"
}

src_install() {
	toolchain_src_install
	cd "${D}"${BINPATH}
	for x in gnat*; do
		# For some reason, g77 gets made instead of ${CTARGET}-g77...
		# this should take care of that
		if [[ -f ${x} ]] ; then
			# In case they're hardlinks, clear out the target first
			# otherwise the mv below will complain.
			rm -f ${CTARGET}-${x}
			mv ${x} ${CTARGET}-${x}
		fi

		if [[ -f ${CTARGET}-${x} ]] ; then
			if ! is_crosscompile ; then
				ln -sf ${CTARGET}-${x} ${x}
				dosym ${BINPATH#${EPREFIX}}/${CTARGET}-${x} \
					/usr/bin/${x}-${GCC_CONFIG_VER}
			fi
			# Create versioned symlinks
			dosym ${BINPATH#${EPREFIX}}/${CTARGET}-${x} \
				/usr/bin/${CTARGET}-${x}-${GCC_CONFIG_VER}
		fi

		if [[ -f ${CTARGET}-${x}-${GCC_CONFIG_VER} ]] ; then
			rm -f ${CTARGET}-${x}-${GCC_CONFIG_VER}
			ln -sf ${CTARGET}-${x} ${CTARGET}-${x}-${GCC_CONFIG_VER}
		fi
	done
}

pkg_postinst () {
	toolchain_pkg_postinst
	einfo "This package provide the GNAT compiler with gcc for ada/c/c++"
	einfo "Even if the c/c++ compilers are using almost the same patched"
	einfo "source as the sys-devel/gcc package its use is not extensively"
	einfo "tested."
	einfo "Using this the c/c++ compiler to update your system, except for ada"
	einfo "related packages, is not supported"
}
