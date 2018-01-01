# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PATCH_VER="1.0"

TOOLCHAIN_GCC_PV=6.3.0

inherit eutils toolchain-funcs toolchain

REL=6
MYP=gcc-${REL}-gpl-${PV}-src

DESCRIPTION="GNAT Ada Compiler - GPL version"
HOMEPAGE="http://libre.adacore.com/"
SRC_URI+="
	http://mirrors.cdn.adacore.com/art/591adbb4c7a4473fcc4532a3
		-> ${P}-src.tar.gz
	http://mirrors.cdn.adacore.com/art/591adb65c7a4473fcbb153ac
		-> ${MYP}.tar.gz
	http://mirrors.cdn.adacore.com/art/591adbc5c7a4473fcbb153ae
		-> gcc-interface-${REL}-gpl-${PV}-src.tar.gz
	bootstrap? (
		http://mirrors.cdn.adacore.com/art/564b3ebec8e196b040fbe66c ->
			gnat-gpl-2014-x86_64-linux-bin.tar.gz
	)"

LICENSE+=" GPL-2 GPL-3"
SLOT="${TOOLCHAIN_GCC_PV}"
KEYWORDS="amd64"
IUSE="bootstrap"

RDEPEND="!sys-devel/gcc:${TOOLCHAIN_GCC_PV}"
DEPEND="${RDEPEND}
	elibc_glibc? ( >=sys-libs/glibc-2.13 )
	>=sys-devel/binutils-2.20"

S="${WORKDIR}"/${MYP}
PDEPEND="${PDEPEND} elibc_glibc? ( >=sys-libs/glibc-2.13 )"
FSFGCC=gcc-${TOOLCHAIN_GCC_PV}

pkg_setup() {
	toolchain_pkg_setup
	if use bootstrap; then
		GCC="${WORKDIR}"/gnat-gpl-2014-x86_64-linux-bin/bin/gcc
	else
		GCC=${ADA:-$(tc-getCC)}
	fi

	gnatbase=$(basename ${GCC})
	gnatpath=$(dirname ${GCC})

	GNATMAKE=${gnatbase/gcc/gnatmake}
	if [[ ${gnatpath} != "." ]] ; then
		GNATMAKE="${gnatpath}/${GNATMAKE}"
	fi

	if ! use bootstrap && [[ -z "$(type ${GNATMAKE} 2>/dev/null)" ]] ; then
		eerror "You need a gcc compiler that provides the Ada Compiler:"
		eerror "1) use gcc-config to select the right compiler or"
		eerror "2) set the bootstrap use flag"
		die "ada compiler not available"
	fi
}

src_unpack() {
	GCC_A_FAKEIT="
		${P}-src.tar.gz
		${MYP}.tar.gz
		gcc-interface-${REL}-gpl-${PV}-src.tar.gz"
	if use bootstrap; then
		GCC_A_FAKEIT="${GCC_A_FAKEIT} gnat-gpl-2014-x86_64-linux-bin.tar.gz"
	fi

	toolchain_src_unpack
	if use bootstrap; then
		rm gnat-gpl-2014-x86_64-linux-bin/libexec/gcc/x86_64-pc-linux-gnu/4.7.4/ld || die
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

	echo ${TOOLCHAIN_GCC_PV} > gcc/BASE-VER

	cd ..
	mv gnat-gpl-${PV}-src/src/ada ${MYP}/gcc/ || die
	mv gcc-interface-${REL}-gpl-${PV}-src ${MYP}/gcc/ada/gcc-interface || die
	epatch "${FILESDIR}"/${P}-gentoo.patch
	cd -
	sed -i \
		-e 's:$(P) ::g' \
		gcc/ada/gcc-interface/Makefile.in \
		|| die "sed failed"
	toolchain_src_prepare
}

src_configure() {
	export PATH=${PWD}/bin:${PATH}
	local trueGCC_BRANCH_VER=${GCC_BRANCH_VER}
	GCC_BRANCH_VER=$(gcc-version)
	downgrade_arch_flags
	GCC_BRANCH_VER=${trueGCC_BRANCH_VER}
	toolchain_src_configure \
		--enable-languages=ada \
		--disable-libada
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
	einfo "This provide the GNAT compiler with gcc for ada/c/c++ and more"
	einfo "Set the ADA variables to ${CTARGET}-gcc-${TOOLCHAIN_GCC_PV} in"
	einfo "your make.conf"
	einfo "Even if the c/c++ compilers are using almost the same patched"
	einfo "source as the sys-devel/gcc package its use is not extensively"
	einfo "tested, and not supported for updating your system, except for ada"
	einfo "related packages"
}
