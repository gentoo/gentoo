# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Maintainer: Toolchain Ninjas <toolchain@gentoo.org>
# @SUPPORTED_EAPIS: 5 6 7

DESCRIPTION="The GNU Compiler Collection"
HOMEPAGE="https://gcc.gnu.org/"

inherit eutils fixheadtails flag-o-matic gnuconfig libtool multilib pax-utils toolchain-funcs prefix

if [[ ${PV} == *9999* ]] ; then
	EGIT_REPO_URI="git://gcc.gnu.org/git/gcc.git"
	# naming style:
	# gcc-10.1.0_pre9999 -> gcc-10-branch
	#  Note that the micro version is required or lots of stuff will break.
	#  To checkout master set gcc_LIVE_BRANCH="master" in the ebuild before
	#  inheriting this eclass.
	EGIT_BRANCH="${PN}-${PV%.?.?_pre9999}-branch"
	EGIT_BRANCH=${EGIT_BRANCH//./_}
	inherit git-r3
fi

FEATURES=${FEATURES/multilib-strict/}

case ${EAPI:-0} in
	0|1|2|3|4*) die "Need to upgrade to at least EAPI=5" ;;
	5*|6) inherit eapi7-ver ;;
	7) ;;
	*) die "I don't speak EAPI ${EAPI}." ;;
esac

EXPORT_FUNCTIONS pkg_pretend pkg_setup src_unpack src_prepare src_configure \
	src_compile src_test src_install pkg_postinst pkg_postrm

#---->> globals <<----

export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} = ${CHOST} ]] ; then
	if [[ ${CATEGORY} == cross-* ]] ; then
		export CTARGET=${CATEGORY#cross-}
	fi
fi
: ${TARGET_ABI:=${ABI}}
: ${TARGET_MULTILIB_ABIS:=${MULTILIB_ABIS}}
: ${TARGET_DEFAULT_ABI:=${DEFAULT_ABI}}

is_crosscompile() {
	[[ ${CHOST} != ${CTARGET} ]]
}

# General purpose version check.  Without a second arg matches up to minor version (x.x.x)
tc_version_is_at_least() {
	ver_test "${2:-${GCC_RELEASE_VER}}" -ge "$1"
}

# General purpose version range check
# Note that it matches up to but NOT including the second version
tc_version_is_between() {
	tc_version_is_at_least "${1}" && ! tc_version_is_at_least "${2}"
}

GCC_PV=${TOOLCHAIN_GCC_PV:-${PV}}
GCC_PVR=${GCC_PV}
[[ ${PR} != "r0" ]] && GCC_PVR=${GCC_PVR}-${PR}
GCC_RELEASE_VER=$(ver_cut 1-3 ${GCC_PV})
GCC_BRANCH_VER=$(ver_cut 1-2 ${GCC_PV})
GCCMAJOR=$(ver_cut 1 ${GCC_PV})
GCCMINOR=$(ver_cut 2 ${GCC_PV})
GCCMICRO=$(ver_cut 3 ${GCC_PV})

# According to gcc/c-cppbuiltin.c, GCC_CONFIG_VER MUST match this regex.
# ([^0-9]*-)?[0-9]+[.][0-9]+([.][0-9]+)?([- ].*)?
GCC_CONFIG_VER=${GCC_CONFIG_VER:-$(ver_rs 3 '-' ${GCC_PV})}

# Pre-release support
if [[ ${GCC_PV} == *_pre* ]] ; then
	PRERELEASE=${GCC_PV/_pre/-}
elif [[ ${GCC_PV} == *_alpha* ]] ; then
	SNAPSHOT=${GCC_BRANCH_VER}-${GCC_PV##*_alpha}
elif [[ ${GCC_PV} == *_beta* ]] ; then
	SNAPSHOT=${GCC_BRANCH_VER}-${GCC_PV##*_beta}
elif [[ ${GCC_PV} == *_rc* ]] ; then
	SNAPSHOT=${GCC_PV%_rc*}-RC-${GCC_PV##*_rc}
fi

if [[ ${SNAPSHOT} == [56789].0-* ]] ; then
	# The gcc-5+ releases have dropped the .0 for some reason.
	SNAPSHOT=${SNAPSHOT/.0}
fi

PREFIX=${TOOLCHAIN_PREFIX:-${EPREFIX}/usr}

if tc_version_is_at_least 3.4.0 ; then
	LIBPATH=${TOOLCHAIN_LIBPATH:-${PREFIX}/lib/gcc/${CTARGET}/${GCC_CONFIG_VER}}
else
	LIBPATH=${TOOLCHAIN_LIBPATH:-${PREFIX}/lib/gcc-lib/${CTARGET}/${GCC_CONFIG_VER}}
fi
INCLUDEPATH=${TOOLCHAIN_INCLUDEPATH:-${LIBPATH}/include}

if is_crosscompile ; then
	BINPATH=${TOOLCHAIN_BINPATH:-${PREFIX}/${CHOST}/${CTARGET}/gcc-bin/${GCC_CONFIG_VER}}
	HOSTLIBPATH=${PREFIX}/${CHOST}/${CTARGET}/lib/${GCC_CONFIG_VER}
else
	BINPATH=${TOOLCHAIN_BINPATH:-${PREFIX}/${CTARGET}/gcc-bin/${GCC_CONFIG_VER}}
fi

DATAPATH=${TOOLCHAIN_DATAPATH:-${PREFIX}/share/gcc-data/${CTARGET}/${GCC_CONFIG_VER}}

# Dont install in /usr/include/g++-v3/, but in gcc internal directory.
# We will handle /usr/include/g++-v3/ with gcc-config ...
STDCXX_INCDIR=${TOOLCHAIN_STDCXX_INCDIR:-${LIBPATH}/include/g++-v${GCC_BRANCH_VER/\.*/}}

#---->> LICENSE+SLOT+IUSE logic <<----

if tc_version_is_at_least 4.6 ; then
	LICENSE="GPL-3+ LGPL-3+ || ( GPL-3+ libgcc libstdc++ gcc-runtime-library-exception-3.1 ) FDL-1.3+"
elif tc_version_is_at_least 4.4 ; then
	LICENSE="GPL-3+ LGPL-3+ || ( GPL-3+ libgcc libstdc++ gcc-runtime-library-exception-3.1 ) FDL-1.2+"
elif tc_version_is_at_least 4.3 ; then
	LICENSE="GPL-3+ LGPL-3+ || ( GPL-3+ libgcc libstdc++ ) FDL-1.2+"
elif tc_version_is_at_least 4.2 ; then
	LICENSE="GPL-3+ LGPL-2.1+ || ( GPL-3+ libgcc libstdc++ ) FDL-1.2+"
elif tc_version_is_at_least 3.3 ; then
	LICENSE="GPL-2+ LGPL-2.1+ FDL-1.2+"
else
	LICENSE="GPL-2+ LGPL-2.1+ FDL-1.1+"
fi

IUSE="test vanilla +nls"
RESTRICT="!test? ( test )"

tc_supports_dostrip() {
	case ${EAPI:-0} in
		5*|6) return 1 ;;
		7) return 0 ;;
		*) die "Update apply_patches() for ${EAPI}." ;;
	esac
}

tc_supports_dostrip || RESTRICT+=" strip" # cross-compilers need controlled stripping

TC_FEATURES=()

tc_has_feature() {
	has "$1" "${TC_FEATURES[@]}"
}

if [[ ${PN} != "kgcc64" && ${PN} != gcc-* ]] ; then
	IUSE+=" altivec debug +cxx +nptl" TC_FEATURES+=(nptl)
	[[ -n ${PIE_VER} ]] && IUSE+=" nopie"
	[[ -n ${HTB_VER} ]] && IUSE+=" boundschecking"
	[[ -n ${D_VER}   ]] && IUSE+=" d"
	[[ -n ${SPECS_VER} ]] && IUSE+=" nossp"
	# fortran support appeared in 4.1, but 4.1 needs outdated mpfr
	tc_version_is_at_least 4.2 && IUSE+=" +fortran" TC_FEATURES+=(fortran)
	tc_version_is_at_least 3 && IUSE+=" doc hardened multilib objc"
	tc_version_is_between 3 7 && IUSE+=" awt gcj" TC_FEATURES+=(gcj)
	tc_version_is_at_least 3.3 && IUSE+=" pgo"
	tc_version_is_at_least 4.0 &&
		IUSE+=" objc-gc" TC_FEATURES+=(objc-gc)
	tc_version_is_between 4.0 4.9 && IUSE+=" mudflap"
	tc_version_is_at_least 4.1 && IUSE+=" libssp objc++"
	tc_version_is_at_least 4.2 && IUSE+=" +openmp"
	tc_version_is_at_least 4.3 && IUSE+=" fixed-point"
	tc_version_is_at_least 4.7 && IUSE+=" go"
	tc_version_is_at_least 4.8 &&
		IUSE+=" +sanitize"
	# Note:
	#   <gcc-4.8 supported graphite, it required forked ppl
	#     versions which we dropped.  Since graphite was also experimental in
	#     the older versions, we don't want to bother supporting it.  #448024
	#   <gcc-5 supported graphite, it required cloog
	#   <gcc-6.5 supported graphite, it required old incompatible isl
	tc_version_is_at_least 6.5 &&
		IUSE+=" graphite" TC_FEATURES+=(graphite)
	tc_version_is_between 4.9 8 && IUSE+=" cilk"
	tc_version_is_at_least 4.9 && IUSE+=" +vtv"
	tc_version_is_at_least 5.0 && IUSE+=" jit"
	tc_version_is_between 5.0 9 && IUSE+=" mpx"
	tc_version_is_at_least 6.0 && IUSE+=" +pie +ssp +pch"
	# systemtap is a gentoo-specific switch: bug #654748
	tc_version_is_at_least 8.0 &&
		IUSE+=" systemtap" TC_FEATURES+=(systemtap)
	tc_version_is_at_least 9.0 && IUSE+=" d"
	tc_version_is_at_least 9.1 && IUSE+=" lto"
fi

if tc_version_is_at_least 10; then
	# Note: currently we pull in prereleases, snapshots and
	# git versions into the same SLOT.
	SLOT="${GCCMAJOR}"
else
	SLOT="${GCC_CONFIG_VER}"
fi

#---->> DEPEND <<----

RDEPEND="sys-libs/zlib
	nls? ( virtual/libintl )"

tc_version_is_at_least 3 && RDEPEND+=" virtual/libiconv"

if tc_version_is_at_least 4 ; then
	GMP_MPFR_DEPS=">=dev-libs/gmp-4.3.2:0= >=dev-libs/mpfr-2.4.2:0="
	if tc_version_is_at_least 4.3 ; then
		RDEPEND+=" ${GMP_MPFR_DEPS}"
	elif tc_has_feature fortran ; then
		RDEPEND+=" fortran? ( ${GMP_MPFR_DEPS} )"
	fi
fi

tc_version_is_at_least 4.5 && RDEPEND+=" >=dev-libs/mpc-0.8.1:0="

if tc_has_feature objc-gc ; then
	if tc_version_is_at_least 7 ; then
		RDEPEND+=" objc-gc? ( >=dev-libs/boehm-gc-7.4.2 )"
	fi
fi

if tc_has_feature graphite ; then
	RDEPEND+=" graphite? ( >=dev-libs/isl-0.14:0= )"
fi

DEPEND="${RDEPEND}
	>=sys-devel/bison-1.875
	>=sys-devel/flex-2.5.4
	nls? ( sys-devel/gettext )
	test? (
		>=dev-util/dejagnu-1.4.4
		>=sys-devel/autogen-5.5.4
	)"

if tc_has_feature gcj ; then
	GCJ_DEPS=">=media-libs/libart_lgpl-2.1"
	GCJ_GTK_DEPS="
		x11-base/xorg-proto
		x11-libs/libXt
		x11-libs/libX11
		x11-libs/libXtst
		=x11-libs/gtk+-2*
		virtual/pkgconfig
	"
	tc_version_is_at_least 3.4 && GCJ_GTK_DEPS+=" x11-libs/pango"
	tc_version_is_at_least 4.2 && GCJ_DEPS+=" app-arch/zip app-arch/unzip"
	DEPEND+=" gcj? ( awt? ( ${GCJ_GTK_DEPS} ) ${GCJ_DEPS} )"
fi

if tc_has_feature systemtap ; then
	# gcc needs sys/sdt.h headers on target
	DEPEND+=" systemtap? ( dev-util/systemtap )"
fi

PDEPEND=">=sys-devel/gcc-config-1.7"

#---->> S + SRC_URI essentials <<----

# Set the source directory depending on whether we're using
# a prerelease, snapshot, or release tarball.
S=$(
	if [[ ${PV} == *9999* ]]; then
		echo ${EGIT_CHECKOUT_DIR}
	elif [[ -n ${PRERELEASE} ]] ; then
		echo ${WORKDIR}/gcc-${PRERELEASE}
	elif [[ -n ${SNAPSHOT} ]] ; then
		echo ${WORKDIR}/gcc-${SNAPSHOT}
	else
		echo ${WORKDIR}/gcc-${GCC_RELEASE_VER}
	fi
)

gentoo_urls() {
	local devspace="HTTP~vapier/dist/URI HTTP~rhill/dist/URI
	HTTP~zorry/patches/gcc/URI HTTP~blueness/dist/URI
	HTTP~tamiko/distfiles/URI HTTP~slyfox/distfiles/URI"
	devspace=${devspace//HTTP/https:\/\/dev.gentoo.org\/}
	echo mirror://gentoo/$1 ${devspace//URI/$1}
}

# This function handles the basics of setting the SRC_URI for a gcc ebuild.
# To use, set SRC_URI with:
#
#	SRC_URI="$(get_gcc_src_uri)"
#
# Other than the variables normally set by portage, this function's behavior
# can be altered by setting the following:
#
#	SNAPSHOT
#			If set, this variable signals that we should be using a snapshot of
#			gcc. It is expected to be in the format "YYYY-MM-DD". Note that if
#			the ebuild has a _pre suffix, this variable is ignored and the
#			prerelease tarball is used instead.
#
#	PATCH_VER
#	PATCH_GCC_VER
#			This should be set to the version of the gentoo patch tarball.
#			The resulting filename of this tarball will be:
#			gcc-${PATCH_GCC_VER:-${GCC_RELEASE_VER}}-patches-${PATCH_VER}.tar.bz2
#
#	PIE_VER
#	PIE_GCC_VER
#			These variables control patching in various updates for the logic
#			controlling Position Independant Executables. PIE_VER is expected
#			to be the version of this patch, and PIE_GCC_VER the gcc version of
#			the patch:
#			An example:
#					PIE_VER="8.7.6.5"
#					PIE_GCC_VER="3.4.0"
#			The resulting filename of this tarball will be:
#			gcc-${PIE_GCC_VER:-${GCC_RELEASE_VER}}-piepatches-v${PIE_VER}.tar.bz2
#
#	SPECS_VER
#	SPECS_GCC_VER
#			This is for the minispecs files included in the hardened gcc-4.x
#			The specs files for hardenedno*, vanilla and for building the "specs" file.
#			SPECS_VER is expected to be the version of this patch, SPECS_GCC_VER
#			the gcc version of the patch.
#			An example:
#					SPECS_VER="8.7.6.5"
#					SPECS_GCC_VER="3.4.0"
#			The resulting filename of this tarball will be:
#			gcc-${SPECS_GCC_VER:-${GCC_RELEASE_VER}}-specs-${SPECS_VER}.tar.bz2
#
#	HTB_VER
#	HTB_GCC_VER
#			These variables control whether or not an ebuild supports Herman
#			ten Brugge's bounds-checking patches. If you want to use a patch
#			for an older gcc version with a new gcc, make sure you set
#			HTB_GCC_VER to that version of gcc.
#
#	CYGWINPORTS_GITREV
#			If set, this variable signals that we should apply additional patches
#			maintained by upstream Cygwin developers at github/cygwinports/gcc,
#			using the specified git commit id there.  The list of patches to
#			apply is extracted from gcc.cygport, maintained there as well.
#			This is done for compilers running on Cygwin, not for cross compilers
#			with a Cygwin target.
get_gcc_src_uri() {
	export PATCH_GCC_VER=${PATCH_GCC_VER:-${GCC_RELEASE_VER}}
	export UCLIBC_GCC_VER=${UCLIBC_GCC_VER:-${PATCH_GCC_VER}}
	export PIE_GCC_VER=${PIE_GCC_VER:-${GCC_RELEASE_VER}}
	export HTB_GCC_VER=${HTB_GCC_VER:-${GCC_RELEASE_VER}}
	export SPECS_GCC_VER=${SPECS_GCC_VER:-${GCC_RELEASE_VER}}

	# Set where to download gcc itself depending on whether we're using a
	# prerelease, snapshot, or release tarball.
	if [[ ${PV} == *9999* ]] ; then
		# Nothing to do w/git snapshots.
		:
	elif [[ -n ${PRERELEASE} ]] ; then
		GCC_SRC_URI="ftp://gcc.gnu.org/pub/gcc/prerelease-${PRERELEASE}/gcc-${PRERELEASE}.tar.bz2"
	elif [[ -n ${SNAPSHOT} ]] ; then
		if tc_version_is_between 5.5 6 || tc_version_is_between 6.4 7 || tc_version_is_at_least 7.2 ; then
			GCC_SRC_URI="ftp://gcc.gnu.org/pub/gcc/snapshots/${SNAPSHOT}/gcc-${SNAPSHOT}.tar.xz"
		else
			GCC_SRC_URI="ftp://gcc.gnu.org/pub/gcc/snapshots/${SNAPSHOT}/gcc-${SNAPSHOT}.tar.bz2"
		fi
	else
		if tc_version_is_between 5.5 6 || tc_version_is_between 6.4 7 || tc_version_is_at_least 7.2 ; then
			GCC_SRC_URI="mirror://gnu/gcc/gcc-${GCC_PV}/gcc-${GCC_RELEASE_VER}.tar.xz"
		else
			GCC_SRC_URI="mirror://gnu/gcc/gcc-${GCC_PV}/gcc-${GCC_RELEASE_VER}.tar.bz2"
		fi
	fi

	[[ -n ${UCLIBC_VER} ]] && \
		GCC_SRC_URI+=" $(gentoo_urls gcc-${UCLIBC_GCC_VER}-uclibc-patches-${UCLIBC_VER}.tar.bz2)"
	[[ -n ${PATCH_VER} ]] && \
		GCC_SRC_URI+=" $(gentoo_urls gcc-${PATCH_GCC_VER}-patches-${PATCH_VER}.tar.bz2)"

	[[ -n ${PIE_VER} ]] && \
		PIE_CORE=${PIE_CORE:-gcc-${PIE_GCC_VER}-piepatches-v${PIE_VER}.tar.bz2} && \
		GCC_SRC_URI+=" $(gentoo_urls ${PIE_CORE})"

	# gcc minispec for the hardened gcc 4 compiler
	[[ -n ${SPECS_VER} ]] && \
		GCC_SRC_URI+=" $(gentoo_urls gcc-${SPECS_GCC_VER}-specs-${SPECS_VER}.tar.bz2)"

	# gcc bounds checking patch
	if [[ -n ${HTB_VER} ]] ; then
		local HTBFILE="bounds-checking-gcc-${HTB_GCC_VER}-${HTB_VER}.patch.bz2"
		GCC_SRC_URI+="
			boundschecking? (
				mirror://sourceforge/boundschecking/${HTBFILE}
				$(gentoo_urls ${HTBFILE})
			)"
	fi

	[[ -n ${D_VER} ]] && \
		GCC_SRC_URI+=" d? ( mirror://sourceforge/dgcc/gdc-${D_VER}-src.tar.bz2 )"

	if tc_has_feature gcj ; then
		if tc_version_is_at_least 4.5 ; then
			GCC_SRC_URI+=" gcj? ( ftp://sourceware.org/pub/java/ecj-4.5.jar )"
		elif tc_version_is_at_least 4.3 ; then
			GCC_SRC_URI+=" gcj? ( ftp://sourceware.org/pub/java/ecj-4.3.jar )"
		fi
	fi

	# Cygwin patches from https://github.com/cygwinports/gcc
	[[ -n ${CYGWINPORTS_GITREV} ]] && \
		GCC_SRC_URI+=" elibc_Cygwin? ( https://github.com/cygwinports/gcc/archive/${CYGWINPORTS_GITREV}.tar.gz
			-> gcc-cygwinports-${CYGWINPORTS_GITREV}.tar.gz )"

	echo "${GCC_SRC_URI}"
}

SRC_URI=$(get_gcc_src_uri)

#---->> pkg_pretend <<----

toolchain_pkg_pretend() {
	if [[ -n ${PRERELEASE}${SNAPSHOT} || ${PV} == *9999* ]] &&
	   [[ -z ${I_PROMISE_TO_SUPPLY_PATCHES_WITH_BUGS} ]] ; then
		die "Please \`export I_PROMISE_TO_SUPPLY_PATCHES_WITH_BUGS=1\` or define it" \
			"in your make.conf if you want to use this version."
	fi

	if ! use_if_iuse cxx ; then
		use_if_iuse go && ewarn 'Go requires a C++ compiler, disabled due to USE="-cxx"'
		use_if_iuse objc++ && ewarn 'Obj-C++ requires a C++ compiler, disabled due to USE="-cxx"'
		use_if_iuse gcj && ewarn 'GCJ requires a C++ compiler, disabled due to USE="-cxx"'
	fi

	want_minispecs
}

#---->> pkg_setup <<----

toolchain_pkg_setup() {
	# we dont want to use the installed compiler's specs to build gcc
	unset GCC_SPECS
	unset LANGUAGES #265283
}

#---->> src_unpack <<----

toolchain_src_unpack() {
	if [[ ${PV} == *9999* ]]; then
		git-r3_src_unpack
	else
		gcc_quick_unpack
	fi
}

gcc_quick_unpack() {
	pushd "${WORKDIR}" > /dev/null
	export PATCH_GCC_VER=${PATCH_GCC_VER:-${GCC_RELEASE_VER}}
	export UCLIBC_GCC_VER=${UCLIBC_GCC_VER:-${PATCH_GCC_VER}}
	export PIE_GCC_VER=${PIE_GCC_VER:-${GCC_RELEASE_VER}}
	export HTB_GCC_VER=${HTB_GCC_VER:-${GCC_RELEASE_VER}}
	export SPECS_GCC_VER=${SPECS_GCC_VER:-${GCC_RELEASE_VER}}

	# Injection point for more tarballs. dev-lang/gnat-gpl uses
	# 'GCC_A_FAKEIT' to specify it's own source and binary tarballs.
	if [[ -n ${GCC_A_FAKEIT} ]] ; then
		unpack ${GCC_A_FAKEIT}
	elif [[ -n ${PRERELEASE} ]] ; then
		unpack gcc-${PRERELEASE}.tar.bz2
	elif [[ -n ${SNAPSHOT} ]] ; then
		if tc_version_is_between 5.5 6 || tc_version_is_between 6.4 7 || tc_version_is_at_least 7.2 ; then
			unpack gcc-${SNAPSHOT}.tar.xz
		else
			unpack gcc-${SNAPSHOT}.tar.bz2
		fi
	elif [[ ${PV} != *9999* ]] ; then
		if tc_version_is_between 5.5 6 || tc_version_is_between 6.4 7 || tc_version_is_at_least 7.2 ; then
			unpack gcc-${GCC_RELEASE_VER}.tar.xz
		else
			unpack gcc-${GCC_RELEASE_VER}.tar.bz2
		fi
	fi

	if [[ -n ${D_VER} ]] && use d ; then
		pushd "${S}"/gcc > /dev/null
		unpack gdc-${D_VER}-src.tar.bz2
		cd ..
		ebegin "Adding support for the D language"
		./gcc/d/setup-gcc.sh >& "${T}"/dgcc.log
		if ! eend $? ; then
			eerror "The D GCC package failed to apply"
			eerror "Please include this log file when posting a bug report:"
			eerror "  ${T}/dgcc.log"
			die "failed to include the D language"
		fi
		popd > /dev/null
	fi

	[[ -n ${PATCH_VER} ]] && \
		unpack gcc-${PATCH_GCC_VER}-patches-${PATCH_VER}.tar.bz2

	[[ -n ${UCLIBC_VER} ]] && \
		unpack gcc-${UCLIBC_GCC_VER}-uclibc-patches-${UCLIBC_VER}.tar.bz2

	if want_pie ; then
		if [[ -n ${PIE_CORE} ]] ; then
			unpack ${PIE_CORE}
		else
			unpack gcc-${PIE_GCC_VER}-piepatches-v${PIE_VER}.tar.bz2
		fi
		[[ -n ${SPECS_VER} ]] && \
			unpack gcc-${SPECS_GCC_VER}-specs-${SPECS_VER}.tar.bz2
	fi

	use_if_iuse boundschecking && unpack "bounds-checking-gcc-${HTB_GCC_VER}-${HTB_VER}.patch.bz2"

	[[ -n ${CYGWINPORTS_GITREV} ]] && use elibc_Cygwin && unpack "gcc-cygwinports-${CYGWINPORTS_GITREV}.tar.gz"

	popd > /dev/null
}

#---->> src_prepare <<----

# 'epatch' is not available in EAPI=7. Abstract away patchset application
# until we eventually get all gcc ebuilds on EAPI=7 or later.
tc_apply_patches() {
	[[ ${#@} -lt 2 ]] && die "usage: tc_apply_patches <message> <patches...>"

	einfo "$1"; shift

	case ${EAPI:-0} in
		# Note: even for EAPI=6 we used 'epatch' semantics. To avoid
		# breaking existing ebuilds use 'eapply' only in EAPI=7 or later.
		5*|6) epatch "$@" ;;
		7) eapply "$@" ;;
		*) die "Update apply_patches() for ${EAPI}." ;;
	esac
}

toolchain_src_prepare() {
	export BRANDING_GCC_PKGVERSION="Gentoo ${GCC_PVR}"
	cd "${S}"

	do_gcc_gentoo_patches
	do_gcc_HTB_patches
	do_gcc_PIE_patches
	do_gcc_CYGWINPORTS_patches

	case ${EAPI:-0} in
		5*) epatch_user;;
		6|7) eapply_user ;;
		*) die "Update toolchain_src_prepare() for ${EAPI}." ;;
	esac

	if ( tc_version_is_at_least 4.8.2 || use_if_iuse hardened ) && ! use vanilla ; then
		make_gcc_hard
	fi

	# install the libstdc++ python into the right location
	# http://gcc.gnu.org/PR51368
	if tc_version_is_between 4.5 4.7 ; then
		sed -i \
			'/^pythondir =/s:=.*:= $(datadir)/python:' \
			"${S}"/libstdc++-v3/python/Makefile.in || die
	fi

	# make sure the pkg config files install into multilib dirs.
	# since we configure with just one --libdir, we can't use that
	# (as gcc itself takes care of building multilibs).  #435728
	find "${S}" -name Makefile.in \
		-exec sed -i '/^pkgconfigdir/s:=.*:=$(toolexeclibdir)/pkgconfig:' {} +

	# No idea when this first started being fixed, but let's go with 4.3.x for now
	if ! tc_version_is_at_least 4.3 ; then
		fix_files=""
		for x in contrib/test_summary libstdc++-v3/scripts/check_survey.in ; do
			[[ -e ${x} ]] && fix_files="${fix_files} ${x}"
		done
		ht_fix_file ${fix_files} */configure *.sh */Makefile.in
	fi

	setup_multilib_osdirnames
	gcc_version_patch

	if tc_version_is_at_least 4.1 ; then
		if [[ -n ${SNAPSHOT} || -n ${PRERELEASE} ]] ; then
			# BASE-VER must be a three-digit version number
			# followed by an optional -pre string
			#   eg. 4.5.1, 4.6.2-pre20120213, 4.7.0-pre9999
			# If BASE-VER differs from ${PV/_/-} then libraries get installed in
			# the wrong directory.
			echo ${PV/_/-} > "${S}"/gcc/BASE-VER
		fi
	fi

	# >= gcc-4.3 doesn't bundle ecj.jar, so copy it
	if tc_version_is_at_least 4.3 && use_if_iuse gcj ; then
		if tc_version_is_at_least 4.5 ; then
			einfo "Copying ecj-4.5.jar"
			cp -pPR "${DISTDIR}/ecj-4.5.jar" "${S}/ecj.jar" || die
		else
			einfo "Copying ecj-4.3.jar"
			cp -pPR "${DISTDIR}/ecj-4.3.jar" "${S}/ecj.jar" || die
		fi
	fi

	# disable --as-needed from being compiled into gcc specs
	# natively when using a gcc version < 3.4.4
	# http://gcc.gnu.org/PR14992
	if ! tc_version_is_at_least 3.4.4 ; then
		sed -i -e s/HAVE_LD_AS_NEEDED/USE_LD_AS_NEEDED/g "${S}"/gcc/config.in
	fi

	# In gcc 3.3.x and 3.4.x, rename the java bins to gcc-specific names
	# in line with gcc-4.
	if tc_version_is_between 3.3 4.0 ; then
		do_gcc_rename_java_bins
	fi

	# Prevent libffi from being installed
	if tc_version_is_between 3.0 4.8 ; then
		sed -i -e 's/\(install.*:\) install-.*recursive/\1/' "${S}"/libffi/Makefile.in || die
		sed -i -e 's/\(install-data-am:\).*/\1/' "${S}"/libffi/include/Makefile.in || die
	fi

	# Fixup libtool to correctly generate .la files with portage
	elibtoolize --portage --shallow --no-uclibc

	gnuconfig_update

	# update configure files
	local f
	einfo "Fixing misc issues in configure files"
	for f in $(grep -l 'autoconf version 2.13' $(find "${S}" -name configure)) ; do
		ebegin "  Updating ${f/${S}\/} [LANG]"
		patch "${f}" "${FILESDIR}"/gcc-configure-LANG.patch >& "${T}"/configure-patch.log \
			|| eerror "Please file a bug about this"
		eend $?
	done
	sed -i 's|A-Za-z0-9|[:alnum:]|g' "${S}"/gcc/*.awk #215828

	# Prevent new texinfo from breaking old versions (see #198182, #464008)
	if tc_version_is_at_least 4.1; then
		tc_apply_patches "Remove texinfo (bug #198182, bug ##464008)" "${FILESDIR}"/gcc-configure-texinfo.patch
	fi

	# >=gcc-4
	if [[ -x contrib/gcc_update ]] ; then
		einfo "Touching generated files"
		./contrib/gcc_update --touch | \
			while read f ; do
				einfo "  ${f%%...}"
			done
	fi
}

do_gcc_gentoo_patches() {
	if ! use vanilla ; then
		if [[ -n ${PATCH_VER} ]] ; then
			tc_apply_patches "Applying Gentoo patches ..." "${WORKDIR}"/patch/*.patch
			BRANDING_GCC_PKGVERSION="${BRANDING_GCC_PKGVERSION} p${PATCH_VER}"
		fi
		if [[ -n ${UCLIBC_VER} ]] ; then
			tc_apply_patches "Applying uClibc patches ..." "${WORKDIR}"/uclibc/*.patch
		fi
	fi
}

do_gcc_HTB_patches() {
	use_if_iuse boundschecking || return 0

	# modify the bounds checking patch with a regression patch
	tc_apply_patches "Bounds checking patch" "${WORKDIR}/bounds-checking-gcc-${HTB_GCC_VER}-${HTB_VER}.patch"
	BRANDING_GCC_PKGVERSION="${BRANDING_GCC_PKGVERSION}, HTB-${HTB_GCC_VER}-${HTB_VER}"
}

do_gcc_PIE_patches() {
	want_pie || return 0
	use vanilla && return 0

	tc_apply_patches "Applying pie patches ..." "${WORKDIR}"/piepatch/*.patch

	BRANDING_GCC_PKGVERSION="${BRANDING_GCC_PKGVERSION}, pie-${PIE_VER}"
}

do_gcc_CYGWINPORTS_patches() {
	[[ -n ${CYGWINPORTS_GITREV} ]] || return 0
	use elibc_Cygwin || return 0

	local p d="${WORKDIR}/gcc-${CYGWINPORTS_GITREV}"
	# readarray -t is available since bash-4.4 only, #690686
	local patches=( $(sed -e '1,/PATCH_URI="/d;/"/,$d' < "${d}"/gcc.cygport) )
	tc_apply_patches "Applying cygwin port patches ..." ${patches[*]}
}

# configure to build with the hardened GCC specs as the default
make_gcc_hard() {
	local gcc_hard_flags=""

	# If we use gcc-6 or newer with pie enable to compile older gcc we need to pass -no-pie
	# to stage1; bug #618908
	if ! tc_version_is_at_least 6.0 && [[ $(gcc-major-version) -ge 6 ]] ; then
		einfo "Disabling PIE in stage1 (only) ..."
		sed -i -e "/^STAGE1_LDFLAGS/ s/$/ -no-pie/" "${S}"/Makefile.in || die
	fi

	# Gcc >= 6.X we can use configurations options to turn pie/ssp on as default
	if tc_version_is_at_least 6.0 ; then
		if use_if_iuse pie ; then
			einfo "Updating gcc to use automatic PIE building ..."
		fi
		if use_if_iuse ssp ; then
			einfo "Updating gcc to use automatic SSP building ..."
		fi
		if use_if_iuse hardened ; then
			# Will add some hardened options as default, like:
			# -fstack-clash-protection
			# -z now
			# see *_all_extra-options.patch gcc patches.
			gcc_hard_flags+=" -DEXTRA_OPTIONS"
			# rebrand to make bug reports easier
			BRANDING_GCC_PKGVERSION=${BRANDING_GCC_PKGVERSION/Gentoo/Gentoo Hardened}
		fi
	else
		if use_if_iuse hardened ; then
			# rebrand to make bug reports easier
			BRANDING_GCC_PKGVERSION=${BRANDING_GCC_PKGVERSION/Gentoo/Gentoo Hardened}
			if hardened_gcc_works ; then
				einfo "Updating gcc to use automatic PIE + SSP building ..."
				gcc_hard_flags+=" -DEFAULT_PIE_SSP"
			elif hardened_gcc_works pie ; then
				einfo "Updating gcc to use automatic PIE building ..."
				ewarn "SSP has not been enabled by default"
				gcc_hard_flags+=" -DEFAULT_PIE"
			elif hardened_gcc_works ssp ; then
				einfo "Updating gcc to use automatic SSP building ..."
				ewarn "PIE has not been enabled by default"
				gcc_hard_flags+=" -DEFAULT_SSP"
			else
				# do nothing if hardened isn't supported, but don't die either
				ewarn "hardened is not supported for this arch in this gcc version"
				return 0
			fi
		else
			if hardened_gcc_works ssp ; then
				einfo "Updating gcc to use automatic SSP building ..."
				gcc_hard_flags+=" -DEFAULT_SSP"
			fi
		fi
	fi

	# we want to be able to control the pie patch logic via something other
	# than ALL_CFLAGS...
	sed -e '/^ALL_CFLAGS/iHARD_CFLAGS = ' \
		-e 's|^ALL_CFLAGS = |ALL_CFLAGS = $(HARD_CFLAGS) |' \
		-i "${S}"/gcc/Makefile.in
	# Need to add HARD_CFLAGS to ALL_CXXFLAGS on >= 4.7
	if tc_version_is_at_least 4.7 ; then
		sed -e '/^ALL_CXXFLAGS/iHARD_CFLAGS = ' \
			-e 's|^ALL_CXXFLAGS = |ALL_CXXFLAGS = $(HARD_CFLAGS) |' \
			-i "${S}"/gcc/Makefile.in
	fi

	sed -i \
		-e "/^HARD_CFLAGS = /s|=|= ${gcc_hard_flags} |" \
		"${S}"/gcc/Makefile.in || die

}

# This is a historical wart.  The original Gentoo/amd64 port used:
#    lib32 - 32bit binaries (x86)
#    lib64 - 64bit binaries (x86_64)
#    lib   - "native" binaries (a symlink to lib64)
# Most other distros use the logic (including mainline gcc):
#    lib   - 32bit binaries (x86)
#    lib64 - 64bit binaries (x86_64)
# Over time, Gentoo is migrating to the latter form.
#
# Unfortunately, due to distros picking the lib32 behavior, newer gcc
# versions will dynamically detect whether to use lib or lib32 for its
# 32bit multilib.  So, to keep the automagic from getting things wrong
# while people are transitioning from the old style to the new style,
# we always set the MULTILIB_OSDIRNAMES var for relevant targets.
setup_multilib_osdirnames() {
	is_multilib || return 0

	local config
	local libdirs="../lib64 ../lib32"

	# this only makes sense for some Linux targets
	case ${CTARGET} in
	x86_64*-linux*)    config="i386" ;;
	powerpc64*-linux*) config="rs6000" ;;
	sparc64*-linux*)   config="sparc" ;;
	s390x*-linux*)     config="s390" ;;
	*)	               return 0 ;;
	esac
	config+="/t-linux64"

	local sed_args=()
	if tc_version_is_at_least 4.6 ; then
		sed_args+=( -e 's:$[(]call if_multiarch[^)]*[)]::g' )
	fi
	if [[ ${SYMLINK_LIB} == "yes" ]] ; then
		einfo "updating multilib directories to be: ${libdirs}"
		if tc_version_is_at_least 4.6.4 || tc_version_is_at_least 4.7 ; then
			sed_args+=( -e '/^MULTILIB_OSDIRNAMES.*lib32/s:[$][(]if.*):../lib32:' )
		else
			sed_args+=( -e "/^MULTILIB_OSDIRNAMES/s:=.*:= ${libdirs}:" )
		fi
	else
		einfo "using upstream multilib; disabling lib32 autodetection"
		sed_args+=( -r -e 's:[$][(]if.*,(.*)[)]:\1:' )
	fi
	sed -i "${sed_args[@]}" "${S}"/gcc/config/${config} || die
}

gcc_version_patch() {
	# gcc-4.3+ has configure flags (whoo!)
	tc_version_is_at_least 4.3 && return 0

	local version_string=${GCC_CONFIG_VER}

	einfo "patching gcc version: ${version_string} (${BRANDING_GCC_PKGVERSION})"

	local gcc_sed=( -e 's:gcc\.gnu\.org/bugs\.html:bugs\.gentoo\.org/:' )
	if grep -qs VERSUFFIX "${S}"/gcc/version.c ; then
		gcc_sed+=( -e "/VERSUFFIX \"\"/s:\"\":\" (${BRANDING_GCC_PKGVERSION})\":" )
	else
		version_string="${version_string} (${BRANDING_GCC_PKGVERSION})"
		gcc_sed+=( -e "/const char version_string\[\] = /s:= \".*\":= \"${version_string}\":" )
	fi
	sed -i "${gcc_sed[@]}" "${S}"/gcc/version.c || die
}

do_gcc_rename_java_bins() {
	# bug #139918 - conflict between gcc and java-config-2 for ownership of
	# /usr/bin/rmi{c,registry}.	 Done with mv & sed rather than a patch
	# because patches would be large (thanks to the rename of man files),
	# and it's clear from the sed invocations that all that changes is the
	# rmi{c,registry} names to grmi{c,registry} names.
	# Kevin F. Quinn 2006-07-12
	einfo "Renaming jdk executables rmic and rmiregistry to grmic and grmiregistry."
	# 1) Move the man files if present (missing prior to gcc-3.4)
	for manfile in rmic rmiregistry ; do
		[[ -f ${S}/gcc/doc/${manfile}.1 ]] || continue
		mv "${S}"/gcc/doc/${manfile}.1 "${S}"/gcc/doc/g${manfile}.1
	done
	# 2) Fixup references in the docs if present (mission prior to gcc-3.4)
	for jfile in gcc/doc/gcj.info gcc/doc/grmic.1 gcc/doc/grmiregistry.1 gcc/java/gcj.texi ; do
		[[ -f ${S}/${jfile} ]] || continue
		sed -i -e 's:rmiregistry:grmiregistry:g' "${S}"/${jfile} ||
			die "Failed to fixup file ${jfile} for rename to grmiregistry"
		sed -i -e 's:rmic:grmic:g' "${S}"/${jfile} ||
			die "Failed to fixup file ${jfile} for rename to grmic"
	done
	# 3) Fixup Makefiles to build the changed executable names
	#	 These are present in all 3.x versions, and are the important bit
	#	 to get gcc to build with the new names.
	for jfile in libjava/Makefile.am libjava/Makefile.in gcc/java/Make-lang.in ; do
		sed -i -e 's:rmiregistry:grmiregistry:g' "${S}"/${jfile} ||
			die "Failed to fixup file ${jfile} for rename to grmiregistry"
		# Careful with rmic on these files; it's also the name of a directory
		# which should be left unchanged.  Replace occurrences of 'rmic$',
		# 'rmic_' and 'rmic '.
		sed -i -e 's:rmic\([$_ ]\):grmic\1:g' "${S}"/${jfile} ||
			die "Failed to fixup file ${jfile} for rename to grmic"
	done
}

#---->> src_configure <<----

toolchain_src_configure() {
	downgrade_arch_flags
	gcc_do_filter_flags

	einfo "CFLAGS=\"${CFLAGS}\""
	einfo "CXXFLAGS=\"${CXXFLAGS}\""
	einfo "LDFLAGS=\"${LDFLAGS}\""

	# Force internal zip based jar script to avoid random
	# issues with 3rd party jar implementations.  #384291
	export JAR=no

	# For hardened gcc 4.3 piepatchset to build the hardened specs
	# file (build.specs) to use when building gcc.
	if ! tc_version_is_at_least 4.4 && want_minispecs ; then
		setup_minispecs_gcc_build_specs
	fi

	local confgcc=( --host=${CHOST} )

	if is_crosscompile || tc-is-cross-compiler ; then
		# Straight from the GCC install doc:
		# "GCC has code to correctly determine the correct value for target
		# for nearly all native systems. Therefore, we highly recommend you
		# not provide a configure target when configuring a native compiler."
		confgcc+=( --target=${CTARGET} )
	fi
	[[ -n ${CBUILD} ]] && confgcc+=( --build=${CBUILD} )

	confgcc+=(
		--prefix="${PREFIX}"
		--bindir="${BINPATH}"
		--includedir="${INCLUDEPATH}"
		--datadir="${DATAPATH}"
		--mandir="${DATAPATH}/man"
		--infodir="${DATAPATH}/info"
		--with-gxx-include-dir="${STDCXX_INCDIR}"
	)

	# Stick the python scripts in their own slotted directory (bug #279252)
	#
	#  --with-python-dir=DIR
	#  Specifies where to install the Python modules used for aot-compile. DIR
	#  should not include the prefix used in installation. For example, if the
	#  Python modules are to be installed in /usr/lib/python2.5/site-packages,
	#  then --with-python-dir=/lib/python2.5/site-packages should be passed.
	#
	# This should translate into "/share/gcc-data/${CTARGET}/${GCC_CONFIG_VER}/python"
	if tc_version_is_at_least 4.4 ; then
		confgcc+=( --with-python-dir=${DATAPATH/$PREFIX/}/python )
	fi

	### language options

	local GCC_LANG="c"
	is_cxx && GCC_LANG+=",c++"
	is_d   && GCC_LANG+=",d"
	is_gcj && GCC_LANG+=",java"
	is_go  && GCC_LANG+=",go"
	is_jit && GCC_LANG+=",jit"
	if is_objc || is_objcxx ; then
		GCC_LANG+=",objc"
		if tc_version_is_at_least 4 ; then
			use objc-gc && confgcc+=( --enable-objc-gc )
		fi
		is_objcxx && GCC_LANG+=",obj-c++"
	fi

	# fortran support just got sillier! the lang value can be f77 for
	# fortran77, f95 for fortran95, or just plain old fortran for the
	# currently supported standard depending on gcc version.
	is_fortran && GCC_LANG+=",fortran"
	is_f77 && GCC_LANG+=",f77"
	is_f95 && GCC_LANG+=",f95"

	# We do NOT want 'ADA support' in here!
	# is_ada && GCC_LANG+=",ada"

	confgcc+=( --enable-languages=${GCC_LANG} )

	### general options

	confgcc+=(
		--enable-obsolete
		--enable-secureplt
		--disable-werror
		--with-system-zlib
	)

	if use nls ; then
		confgcc+=( --enable-nls --without-included-gettext )
	else
		confgcc+=( --disable-nls )
	fi

	tc_version_is_at_least 3.4 || confgcc+=( --disable-libunwind-exceptions )

	# Use the default ("release") checking because upstream usually neglects
	# to test "disabled" so it has a history of breaking. bug #317217
	if tc_version_is_at_least 3.4 && in_iuse debug ; then
		# The "release" keyword is new to 4.0. bug #551636
		local off=$(tc_version_is_at_least 4.0 && echo release || echo no)
		confgcc+=( --enable-checking="${GCC_CHECKS_LIST:-$(usex debug yes ${off})}" )
	fi

	# Branding
	tc_version_is_at_least 4.3 && confgcc+=(
		--with-bugurl=https://bugs.gentoo.org/
		--with-pkgversion="${BRANDING_GCC_PKGVERSION}"
	)

	# If we want hardened support with the newer piepatchset for >=gcc 4.4
	if tc_version_is_at_least 4.4 && want_minispecs && in_iuse hardened ; then
		confgcc+=( $(use_enable hardened esp) )
	fi

	# allow gcc to search for clock funcs in the main C lib.
	# if it can't find them, then tough cookies -- we aren't
	# going to link in -lrt to all C++ apps. bug #411681
	if tc_version_is_at_least 4.4 && is_cxx ; then
		confgcc+=( --enable-libstdcxx-time )
	fi

	# Build compiler itself using LTO
	if tc_version_is_at_least 9.1 && use_if_iuse lto ; then
		confgcc+=( --with-build-config=bootstrap-lto )
	fi

	# Support to disable pch when building libstdcxx
	if tc_version_is_at_least 6.0 && ! use_if_iuse pch ; then
		confgcc+=( --disable-libstdcxx-pch )
	fi

	# The jit language requires this.
	is_jit && confgcc+=( --enable-host-shared )

	# build-id was disabled for file collisions: bug #526144
	#
	# # Turn on the -Wl,--build-id flag by default for ELF targets. bug #525942
	# # This helps with locating debug files.
	# case ${CTARGET} in
	# *-linux-*|*-elf|*-eabi)
	# 	tc_version_is_at_least 4.5 && confgcc+=(
	# 		--enable-linker-build-id
	# 	)
	# 	;;
	# esac

	# newer gcc versions like to bootstrap themselves with C++,
	# so we need to manually disable it ourselves
	if tc_version_is_between 4.7 4.8 && ! is_cxx ; then
		confgcc+=( --disable-build-with-cxx --disable-build-poststage1-with-cxx )
	fi

	### Cross-compiler options
	if is_crosscompile ; then
		# Enable build warnings by default with cross-compilers when system
		# paths are included (e.g. via -I flags).
		confgcc+=( --enable-poison-system-directories )

		# When building a stage1 cross-compiler (just C compiler), we have to
		# disable a bunch of features or gcc goes boom
		local needed_libc=""
		case ${CTARGET} in
		*-linux)		 needed_libc=error-unknown-libc;;
		*-dietlibc)		 needed_libc=dietlibc;;
		*-elf|*-eabi)
			needed_libc=newlib
			# Bare-metal targets don't have access to clock_gettime()
			# arm-none-eabi example: bug #589672
			# But we explicitly do --enable-libstdcxx-time above.
			# Undoing it here.
			confgcc+=( --disable-libstdcxx-time )
			;;
		*-freebsd*)		 needed_libc=freebsd-lib;;
		*-gnu*)			 needed_libc=glibc;;
		*-klibc)		 needed_libc=klibc;;
		*-musl*)		 needed_libc=musl;;
		*-uclibc*)
			# Enable shared library support only on targets
			# that support it: bug #291870
			if ! echo '#include <features.h>' | \
			   $(tc-getCPP ${CTARGET}) -E -dD - 2>/dev/null | \
			   grep -q __HAVE_SHARED__
			then
				confgcc+=( --disable-shared )
			fi
			needed_libc=uclibc-ng
			;;
		*-cygwin)		 needed_libc=cygwin;;
		x86_64-*-mingw*|\
		*-w64-mingw*)	 needed_libc=mingw64-runtime;;
		avr)			 confgcc+=( --enable-shared --disable-threads );;
		esac
		if [[ -n ${needed_libc} ]] ; then
			local confgcc_no_libc=( --disable-shared )
			tc_version_is_at_least 4.8 && confgcc_no_libc+=( --disable-libatomic )
			if ! has_version ${CATEGORY}/${needed_libc} ; then
				confgcc+=(
					"${confgcc_no_libc[@]}"
					--disable-threads
					--without-headers
				)
			elif has_version "${CATEGORY}/${needed_libc}[headers-only(-)]" ; then
				confgcc+=(
					"${confgcc_no_libc[@]}"
					--with-sysroot="${PREFIX}"/${CTARGET}
				)
			else
				confgcc+=( --with-sysroot="${PREFIX}"/${CTARGET} )
			fi
		fi

		tc_version_is_at_least 4.2 && confgcc+=( --disable-bootstrap )
	else
		if tc-is-static-only ; then
			confgcc+=( --disable-shared )
		else
			confgcc+=( --enable-shared )
		fi
		case ${CHOST} in
		mingw*|*-mingw*)
			confgcc+=( --enable-threads=win32 ) ;;
		*)
			confgcc+=( --enable-threads=posix ) ;;
		esac
	fi

	# __cxa_atexit is "essential for fully standards-compliant handling of
	# destructors", but apparently requires glibc.
	case ${CTARGET} in
	*-uclibc*)
		if tc_has_feature nptl ; then
			confgcc+=(
				--disable-__cxa_atexit
				$(use_enable nptl tls)
			)
		fi
		tc_version_is_between 3.3 3.4 && confgcc+=( --enable-sjlj-exceptions )
		if tc_version_is_between 3.4 4.3 ; then
			confgcc+=( --enable-clocale=uclibc )
		fi
		;;
	*-elf|*-eabi)
		confgcc+=( --with-newlib )
		;;
	*-musl*)
		confgcc+=( --enable-__cxa_atexit )
		;;
	*-gnu*)
		confgcc+=(
			--enable-__cxa_atexit
			--enable-clocale=gnu
		)
		;;
	*-freebsd*)
		confgcc+=( --enable-__cxa_atexit )
		;;
	*-solaris*)
		confgcc+=( --enable-__cxa_atexit )
		;;
	esac

	### arch options

	gcc-multilib-configure

	# ppc altivec support
	in_iuse altivec && confgcc+=( $(use_enable altivec) )

	# gcc has fixed-point arithmetic support in 4.3 for mips targets that can
	# significantly increase compile time by several hours.  This will allow
	# users to control this feature in the event they need the support.
	tc_version_is_at_least 4.3 && in_iuse fixed-point && confgcc+=( $(use_enable fixed-point) )

	case $(tc-is-softfloat) in
	yes)    confgcc+=( --with-float=soft ) ;;
	softfp) confgcc+=( --with-float=softfp ) ;;
	*)
		# If they've explicitly opt-ed in, do hardfloat,
		# otherwise let the gcc default kick in.
		case ${CTARGET//_/-} in
		*-hardfloat-*|*eabihf) confgcc+=( --with-float=hard ) ;;
		esac
	esac

	local with_abi_map=()
	case $(tc-arch) in
	arm)	#264534 #414395
		local a arm_arch=${CTARGET%%-*}
		# Remove trailing endian variations first: eb el be bl b l
		for a in e{b,l} {b,l}e b l ; do
			if [[ ${arm_arch} == *${a} ]] ; then
				arm_arch=${arm_arch%${a}}
				break
			fi
		done
		# Convert armv7{a,r,m} to armv7-{a,r,m}
		[[ ${arm_arch} == armv7? ]] && arm_arch=${arm_arch/7/7-}
		# See if this is a valid --with-arch flag
		if (srcdir=${S}/gcc target=${CTARGET} with_arch=${arm_arch};
		    . "${srcdir}"/config.gcc) &>/dev/null
		then
			confgcc+=( --with-arch=${arm_arch} )
		fi

		# Make default mode thumb for microcontroller classes #418209
		[[ ${arm_arch} == *-m ]] && confgcc+=( --with-mode=thumb )

		# Enable hardvfp
		if [[ $(tc-is-softfloat) == "no" ]] && \
		   [[ ${CTARGET} == armv[67]* ]] && \
		   tc_version_is_at_least 4.5
		then
			# Follow the new arm hardfp distro standard by default
			confgcc+=( --with-float=hard )
			case ${CTARGET} in
			armv6*) confgcc+=( --with-fpu=vfp ) ;;
			armv7*) confgcc+=( --with-fpu=vfpv3-d16 ) ;;
			esac
		fi
		;;
	mips)
		# Add --with-abi flags to set default ABI
		confgcc+=( --with-abi=$(gcc-abi-map ${TARGET_DEFAULT_ABI}) )
		;;
	amd64)
		# drop the older/ABI checks once this get's merged into some
		# version of gcc upstream
		if tc_version_is_at_least 4.8 && has x32 $(get_all_abis TARGET) ; then
			confgcc+=( --with-abi=$(gcc-abi-map ${TARGET_DEFAULT_ABI}) )
		fi
		;;
	x86)
		# Default arch for x86 is normally i386, lets give it a bump
		# since glibc will do so based on CTARGET anyways
		confgcc+=( --with-arch=${CTARGET%%-*} )
		;;
	hppa)
		# Enable sjlj exceptions for backward compatibility on hppa
		[[ ${GCCMAJOR} == "3" ]] && confgcc+=( --enable-sjlj-exceptions )
		;;
	ppc)
		# Set up defaults based on current CFLAGS
		is-flagq -mfloat-gprs=double && confgcc+=( --enable-e500-double )
		[[ ${CTARGET//_/-} == *-e500v2-* ]] && confgcc+=( --enable-e500-double )
		;;
	ppc64)
		# On ppc64 big endian target gcc assumes elfv1 by default,
		# and elfv2 on little endian
		# but musl does not support elfv1 at all on any endian ppc64
		# see https://git.musl-libc.org/cgit/musl/tree/INSTALL
		# https://bugs.gentoo.org/704784
		[[ ${CTARGET} == powerpc64-*-musl ]] && confgcc+=( --with-abi=elfv2 )
		;;
	riscv)
		# Add --with-abi flags to set default ABI
		confgcc+=( --with-abi=$(gcc-abi-map ${TARGET_DEFAULT_ABI}) )
		;;
	esac

	# if the target can do biarch (-m32/-m64), enable it.  overhead should
	# be small, and should simplify building of 64bit kernels in a 32bit
	# userland by not needing sys-devel/kgcc64.  #349405
	case $(tc-arch) in
	ppc|ppc64) tc_version_is_at_least 3.4 && confgcc+=( --enable-targets=all ) ;;
	sparc)     tc_version_is_at_least 4.4 && confgcc+=( --enable-targets=all ) ;;
	amd64|x86) tc_version_is_at_least 4.3 && confgcc+=( --enable-targets=all ) ;;
	esac

	# On Darwin we need libdir to be set in order to get correct install names
	# for things like libobjc-gnu, libgcj and libfortran.  If we enable it on
	# non-Darwin we screw up the behaviour this eclass relies on.  We in
	# particular need this over --libdir for bug #255315.
	[[ ${CTARGET} == *-darwin* ]] && \
		confgcc+=( --enable-version-specific-runtime-libs )

	### library options

	if tc_version_is_between 3.0 7.0 ; then
		if is_gcj ; then
			confgcc+=( --disable-gjdoc )
			use awt && confgcc+=( --enable-java-awt=gtk )
		else
			confgcc+=( --disable-libgcj )
		fi
	fi

	if tc_version_is_at_least 4.2 ; then
		if in_iuse openmp ; then
			# Make sure target has pthreads support. #326757 #335883
			# There shouldn't be a chicken & egg problem here as openmp won't
			# build without a C library, and you can't build that w/out
			# already having a compiler ...
			if ! is_crosscompile || \
			   $(tc-getCPP ${CTARGET}) -E - <<<"#include <pthread.h>" >& /dev/null
			then
				confgcc+=( $(use_enable openmp libgomp) )
			else
				# Force disable as the configure script can be dumb #359855
				confgcc+=( --disable-libgomp )
			fi
		else
			# For gcc variants where we don't want openmp (e.g. kgcc)
			confgcc+=( --disable-libgomp )
		fi
	fi

	if tc_version_is_at_least 4.0 ; then
		if in_iuse mudflap ; then
			confgcc+=( $(use_enable mudflap libmudflap) )
		else
			confgcc+=( --disable-libmudflap )
		fi

		if use_if_iuse libssp ; then
			confgcc+=( --enable-libssp )
		else
			if hardened_gcc_is_stable ssp; then
				export gcc_cv_libc_provides_ssp=yes
			fi
			if use_if_iuse ssp; then
				# On some targets USE="ssp -libssp" is an invalid
				# configuration as target libc does not provide
				# stack_chk_* functions. Do not disable libssp there.
				case ${CTARGET} in
					mingw*|*-mingw*) ewarn "Not disabling libssp" ;;
					*) confgcc+=( --disable-libssp ) ;;
				esac
			else
				confgcc+=( --disable-libssp )
			fi
		fi
	fi

	if in_iuse cilk ; then
		confgcc+=( $(use_enable cilk libcilkrts) )
	fi

	if in_iuse mpx ; then
		confgcc+=( $(use_enable mpx libmpx) )
	fi

	if in_iuse systemtap ; then
		confgcc+=( $(use_enable systemtap) )
	fi

	if in_iuse vtv ; then
		confgcc+=(
			$(use_enable vtv vtable-verify)
			# See Note [implicitly enabled flags]
			$(usex vtv '' --disable-libvtv)
		)
	fi

	# newer gcc's come with libquadmath, but only fortran uses
	# it, so auto punt it when we don't care
	if tc_version_is_at_least 4.6 && ! is_fortran ; then
		confgcc+=( --disable-libquadmath )
	fi

	if tc_version_is_at_least 4.6 ; then
		confgcc+=( --enable-lto )
	elif tc_version_is_at_least 4.5 ; then
		confgcc+=( --disable-lto )
	fi

	# graphite was added in 4.4 but we only support it in 6.5+ due to external
	# library issues.  #448024, #701270
	if tc_version_is_at_least 6.5 && in_iuse graphite ; then
		confgcc+=( $(use_with graphite isl) )
		use graphite && confgcc+=( --disable-isl-version-check )
	elif tc_version_is_at_least 5.0 ; then
		confgcc+=( --without-isl )
	elif tc_version_is_at_least 4.8 ; then
		confgcc+=( --without-cloog )
	elif tc_version_is_at_least 4.4 ; then
		confgcc+=( --without-{cloog,ppl} )
	fi

	if tc_version_is_at_least 4.8 && in_iuse sanitize ; then
		# See Note [implicitly enabled flags]
		confgcc+=( $(usex sanitize '' --disable-libsanitizer) )
	fi

	if tc_version_is_at_least 6.0 && in_iuse pie ; then
		confgcc+=( $(use_enable pie default-pie) )
	fi

	if tc_version_is_at_least 6.0 && in_iuse ssp ; then
		confgcc+=(
			# This defaults to -fstack-protector-strong.
			$(use_enable ssp default-ssp)
		)
	fi

	# Disable gcc info regeneration -- it ships with generated info pages
	# already.  Our custom version/urls/etc... trigger it.  #464008
	export gcc_cv_prog_makeinfo_modern=no

	# Do not let the X detection get in our way.  We know things can be found
	# via system paths, so no need to hardcode things that'll break multilib.
	# Older gcc versions will detect ac_x_libraries=/usr/lib64 which ends up
	# killing the 32bit builds which want /usr/lib.
	export ac_cv_have_x='have_x=yes ac_x_includes= ac_x_libraries='

	confgcc+=( "$@" ${EXTRA_ECONF} )

	# Nothing wrong with a good dose of verbosity
	echo
	einfo "PREFIX:          ${PREFIX}"
	einfo "BINPATH:         ${BINPATH}"
	einfo "LIBPATH:         ${LIBPATH}"
	einfo "DATAPATH:        ${DATAPATH}"
	einfo "STDCXX_INCDIR:   ${STDCXX_INCDIR}"
	echo
	einfo "Languages:       ${GCC_LANG}"
	echo
	einfo "Configuring GCC with: ${confgcc[@]//--/\n\t--}"
	echo

	# Build in a separate build tree
	mkdir -p "${WORKDIR}"/build
	pushd "${WORKDIR}"/build > /dev/null

	# and now to do the actual configuration
	addwrite /dev/zero
	echo "${S}"/configure "${confgcc[@]}"
	# Older gcc versions did not detect bash and re-exec itself, so force the
	# use of bash.  Newer ones will auto-detect, but this is not harmful.
	CONFIG_SHELL="${EPREFIX}/bin/bash" \
	bash "${S}"/configure "${confgcc[@]}" || die "failed to run configure"

	# return to whatever directory we were in before
	popd > /dev/null
}

# Replace -m flags unsupported by the version being built with the best
# available equivalent
downgrade_arch_flags() {
	local arch bver i isa myarch mytune rep ver

	bver=${1:-${GCC_BRANCH_VER}}
	[[ $(gcc-version) < ${bver} ]] && return 0
	[[ $(tc-arch) != amd64 && $(tc-arch) != x86 ]] && return 0

	myarch=$(get-flag march)
	mytune=$(get-flag mtune)

	# If -march=native isn't supported we have to tease out the actual arch
	if [[ ${myarch} == native || ${mytune} == native ]] ; then
		if [[ ${bver} < 4.2 ]] ; then
			arch=$($(tc-getCC) -march=native -v -E -P - </dev/null 2>&1 \
				| sed -rn "/cc1.*-march/s:.*-march=([^ ']*).*:\1:p")
			replace-cpu-flags native ${arch}
		fi
	fi

	# Handle special -mtune flags
	[[ ${mytune} == intel && ${bver} < 4.9 ]] && replace-cpu-flags intel generic
	[[ ${mytune} == generic && ${bver} < 4.2 ]] && filter-flags '-mtune=*'
	[[ ${mytune} == x86-64 ]] && filter-flags '-mtune=*'
	[[ ${bver} < 3.4 ]] && filter-flags '-mtune=*'

	# "added" "arch" "replacement"
	local archlist=(
		4.9 bdver4 bdver3
		4.9 bonnell atom
		4.9 broadwell core-avx2
		4.9 haswell core-avx2
		4.9 ivybridge core-avx-i
		4.9 nehalem corei7
		4.9 sandybridge corei7-avx
		4.9 silvermont corei7
		4.9 westmere corei7
		4.8 bdver3 bdver2
		4.8 btver2 btver1
		4.7 bdver2 bdver1
		4.7 core-avx2 core-avx-i
		4.6 bdver1 amdfam10
		4.6 btver1 amdfam10
		4.6 core-avx-i core2
		4.6 corei7 core2
		4.6 corei7-avx core2
		4.5 atom core2
		4.3 amdfam10 k8
		4.3 athlon64-sse3 k8
		4.3 barcelona k8
		4.3 core2 nocona
		4.3 geode k6-2 # gcc.gnu.org/PR41989#c22
		4.3 k8-sse3 k8
		4.3 opteron-sse3 k8
		3.4 athlon-fx x86-64
		3.4 athlon64 x86-64
		3.4 c3-2 c3
		3.4 k8 x86-64
		3.4 opteron x86-64
		3.4 pentium-m pentium3
		3.4 pentium3m pentium3
		3.4 pentium4m pentium4
	)

	for ((i = 0; i < ${#archlist[@]}; i += 3)) ; do
		myarch=$(get-flag march)
		mytune=$(get-flag mtune)

		ver=${archlist[i]}
		arch=${archlist[i + 1]}
		rep=${archlist[i + 2]}

		[[ ${myarch} != ${arch} && ${mytune} != ${arch} ]] && continue

		if [[ ${ver} > ${bver} ]] ; then
			einfo "Replacing ${myarch} (added in gcc ${ver}) with ${rep}..."
			[[ ${myarch} == ${arch} ]] && replace-cpu-flags ${myarch} ${rep}
			[[ ${mytune} == ${arch} ]] && replace-cpu-flags ${mytune} ${rep}
			continue
		else
			break
		fi
	done

	# we only check -mno* here since -m* get removed by strip-flags later on
	local isalist=(
		4.9 -mno-sha
		4.9 -mno-avx512pf
		4.9 -mno-avx512f
		4.9 -mno-avx512er
		4.9 -mno-avx512cd
		4.8 -mno-xsaveopt
		4.8 -mno-xsave
		4.8 -mno-rtm
		4.8 -mno-fxsr
		4.7 -mno-lzcnt
		4.7 -mno-bmi2
		4.7 -mno-avx2
		4.6 -mno-tbm
		4.6 -mno-rdrnd
		4.6 -mno-fsgsbase
		4.6 -mno-f16c
		4.6 -mno-bmi
		4.5 -mno-xop
		4.5 -mno-movbe
		4.5 -mno-lwp
		4.5 -mno-fma4
		4.4 -mno-pclmul
		4.4 -mno-fma
		4.4 -mno-avx
		4.4 -mno-aes
		4.3 -mno-ssse3
		4.3 -mno-sse4a
		4.3 -mno-sse4
		4.3 -mno-sse4.2
		4.3 -mno-sse4.1
		4.3 -mno-popcnt
		4.3 -mno-abm
	)

	for ((i = 0; i < ${#isalist[@]}; i += 2)) ; do
		ver=${isalist[i]}
		isa=${isalist[i + 1]}
		[[ ${ver} > ${bver} ]] && filter-flags ${isa} ${isa/-m/-mno-}
	done
}

gcc_do_filter_flags() {
	strip-flags
	replace-flags -O? -O2

	# dont want to funk ourselves
	filter-flags '-mabi*' -m31 -m32 -m64

	filter-flags -frecord-gcc-switches # 490738
	filter-flags -mno-rtm -mno-htm # 506202

	if tc_version_is_between 3.2 3.4 ; then
		# XXX: this is so outdated it's barely useful, but it don't hurt...
		replace-cpu-flags G3 750
		replace-cpu-flags G4 7400
		replace-cpu-flags G5 7400

		# XXX: should add a sed or something to query all supported flags
		#      from the gcc source and trim everything else ...
		filter-flags -f{no-,}unit-at-a-time -f{no-,}web -mno-tls-direct-seg-refs
		filter-flags -f{no-,}stack-protector{,-all}
		filter-flags -fvisibility-inlines-hidden -fvisibility=hidden
		# and warning options
		filter-flags -Wextra -Wstack-protector
	fi
	if ! tc_version_is_at_least 4.1 ; then
		filter-flags -fdiagnostics-show-option
		filter-flags -Wstack-protector
	fi

	if tc_version_is_between 6 8 ; then
		# -mstackrealign triggers crashes in exception throwing
		# at least on ada: bug #688580
		# The reason is unknown. Drop the flag for now.
		filter-flags -mstackrealign
	fi

	if tc_version_is_at_least 3.4 ; then
		case $(tc-arch) in
			amd64|x86)
				filter-flags '-mcpu=*'

				tc_version_is_between 4.4 4.5 && append-flags -mno-avx # 357287

				if tc_version_is_between 4.6 4.7 ; then
					# https://bugs.gentoo.org/411333
					# https://bugs.gentoo.org/466454
					replace-cpu-flags c3-2 pentium2 pentium3 pentium3m pentium-m i686
				fi
				;;
			alpha)
				# https://bugs.gentoo.org/454426
				append-ldflags -Wl,--no-relax
				;;
			sparc)
				# temporary workaround for random ICEs reproduced by multiple users
				# https://bugs.gentoo.org/457062
				tc_version_is_between 4.6 4.8 && MAKEOPTS+=" -j1"
				;;
			*-macos)
				# http://gcc.gnu.org/PR25127
				tc_version_is_between 4.0 4.2 && \
					filter-flags '-mcpu=*' '-march=*' '-mtune=*'
				;;
		esac
	fi

	strip-unsupported-flags

	# these are set here so we have something sane at configure time
	if is_crosscompile ; then
		# Set this to something sane for both native and target
		CFLAGS="-O2 -pipe"
		FFLAGS=${CFLAGS}
		FCFLAGS=${CFLAGS}

		# "hppa2.0-unknown-linux-gnu" -> hppa2_0_unknown_linux_gnu
		local VAR="CFLAGS_"${CTARGET//[-.]/_}
		CXXFLAGS=${!VAR-${CFLAGS}}
	fi

	export GCJFLAGS=${GCJFLAGS:-${CFLAGS}}
}

setup_minispecs_gcc_build_specs() {
	# Setup the "build.specs" file for gcc 4.3 to use when building.
	if hardened_gcc_works pie ; then
		cat "${WORKDIR}"/specs/pie.specs >> "${WORKDIR}"/build.specs
	fi
	if hardened_gcc_works ssp ; then
		for s in ssp sspall ; do
			cat "${WORKDIR}"/specs/${s}.specs >> "${WORKDIR}"/build.specs
		done
	fi
	for s in nostrict znow ; do
		cat "${WORKDIR}"/specs/${s}.specs >> "${WORKDIR}"/build.specs
	done
	export GCC_SPECS="${WORKDIR}"/build.specs
}

gcc-multilib-configure() {
	if ! is_multilib ; then
		confgcc+=( --disable-multilib )
		# Fun times: if we are building for a target that has multiple
		# possible ABI formats, and the user has told us to pick one
		# that isn't the default, then not specifying it via the list
		# below will break that on us.
	else
		confgcc+=( --enable-multilib )
	fi

	# translate our notion of multilibs into gcc's
	local abi list
	for abi in $(get_all_abis TARGET) ; do
		local l=$(gcc-abi-map ${abi})
		[[ -n ${l} ]] && list+=",${l}"
	done
	if [[ -n ${list} ]] ; then
		case ${CTARGET} in
		x86_64*)
			tc_version_is_at_least 4.8 && confgcc+=( --with-multilib-list=${list:1} )
			;;
		esac
	fi
}

gcc-abi-map() {
	# Convert the ABI name we use in Gentoo to what gcc uses
	local map=()
	case ${CTARGET} in
	mips*)   map=("o32 32" "n32 n32" "n64 64") ;;
	riscv*)  map=("lp64d lp64d" "lp64 lp64") ;;
	x86_64*) map=("amd64 m64" "x86 m32" "x32 mx32") ;;
	esac

	local m
	for m in "${map[@]}" ; do
		l=( ${m} )
		[[ $1 == ${l[0]} ]] && echo ${l[1]} && break
	done
}

#----> src_compile <----

toolchain_src_compile() {
	touch "${S}"/gcc/c-gperf.h

	# Do not make manpages if we do not have perl ...
	[[ ! -x /usr/bin/perl ]] \
		&& find "${WORKDIR}"/build -name '*.[17]' -exec touch {} +

	# Older gcc versions did not detect bash and re-exec itself, so force the
	# use of bash.  Newer ones will auto-detect, but this is not harmful.
	# This needs to be set for compile as well, as it's used in libtool
	# generation, which will break install otherwise (at least in 3.3.6): #664486
	CONFIG_SHELL="${EPREFIX}/bin/bash" \
	gcc_do_make ${GCC_MAKE_TARGET}
}

gcc_do_make() {
	# This function accepts one optional argument, the make target to be used.
	# If omitted, gcc_do_make will try to guess whether it should use all,
	# or bootstrap-lean depending on CTARGET and arch.
	# An example of how to use this function:
	#
	#	gcc_do_make all-target-libstdc++-v3

	[[ -n ${1} ]] && GCC_MAKE_TARGET=${1}

	# default target
	if is_crosscompile || tc-is-cross-compiler ; then
		# 3 stage bootstrapping doesnt quite work when you cant run the
		# resulting binaries natively ^^;
		GCC_MAKE_TARGET=${GCC_MAKE_TARGET-all}
	else
		if tc_version_is_at_least 3.3 && use_if_iuse pgo; then
			GCC_MAKE_TARGET=${GCC_MAKE_TARGET-profiledbootstrap}
		else
			GCC_MAKE_TARGET=${GCC_MAKE_TARGET-bootstrap-lean}
		fi
	fi

	# Older versions of GCC could not do profiledbootstrap in parallel due to
	# collisions with profiling info.
	# boundschecking also seems to introduce parallel build issues.
	if [[ ${GCC_MAKE_TARGET} == "profiledbootstrap" ]] || use_if_iuse boundschecking ; then
		! tc_version_is_at_least 4.6 && export MAKEOPTS="${MAKEOPTS} -j1"
	fi

	if [[ ${GCC_MAKE_TARGET} == "all" ]] ; then
		STAGE1_CFLAGS=${STAGE1_CFLAGS-"${CFLAGS}"}
	elif [[ $(gcc-version) == "3.4" && ${GCC_BRANCH_VER} == "3.4" ]] && gcc-specs-ssp ; then
		# See bug #79852
		STAGE1_CFLAGS=${STAGE1_CFLAGS-"-O2"}
	fi

	if is_crosscompile; then
		# In 3.4, BOOT_CFLAGS is never used on a crosscompile...
		# but I'll leave this in anyways as someone might have had
		# some reason for putting it in here... --eradicator
		BOOT_CFLAGS=${BOOT_CFLAGS-"-O2"}
	else
		# we only want to use the system's CFLAGS if not building a
		# cross-compiler.
		BOOT_CFLAGS=${BOOT_CFLAGS-"$(get_abi_CFLAGS ${TARGET_DEFAULT_ABI}) ${CFLAGS}"}
	fi

	einfo "Compiling ${PN} (${GCC_MAKE_TARGET})..."

	pushd "${WORKDIR}"/build >/dev/null

	emake \
		LDFLAGS="${LDFLAGS}" \
		STAGE1_CFLAGS="${STAGE1_CFLAGS}" \
		LIBPATH="${LIBPATH}" \
		BOOT_CFLAGS="${BOOT_CFLAGS}" \
		${GCC_MAKE_TARGET} \
		|| die "emake failed with ${GCC_MAKE_TARGET}"

	if ! is_crosscompile && use_if_iuse cxx && use_if_iuse doc ; then
		if type -p doxygen > /dev/null ; then
			if tc_version_is_at_least 4.3 ; then
				cd "${CTARGET}"/libstdc++-v3/doc
				emake doc-man-doxygen || ewarn "failed to make docs"
			elif tc_version_is_at_least 3.0 ; then
				cd "${CTARGET}"/libstdc++-v3
				emake doxygen-man || ewarn "failed to make docs"
			fi
			# Clean bogus manpages.  #113902
			find -name '*_build_*' -delete
			# Blow away generated directory references.  Newer versions of gcc
			# have gotten better at this, but not perfect.  This is easier than
			# backporting all of the various doxygen patches.  #486754
			find -name '*_.3' -exec grep -l ' Directory Reference ' {} + | \
				xargs rm -f
		else
			ewarn "Skipping libstdc++ manpage generation since you don't have doxygen installed"
		fi
	fi

	popd >/dev/null
}

#---->> src_test <<----

toolchain_src_test() {
	cd "${WORKDIR}"/build
	# 'asan' wants to be preloaded first, so does 'sandbox'.
	# To make asan tests work disable sandbox for all of test suite.
	# 'backtrace' tests also does not like 'libsandbox.so' presence.
	SANDBOX_ON=0 LD_PRELOAD= emake -k check
}

#---->> src_install <<----

toolchain_src_install() {
	cd "${WORKDIR}"/build

	# Don't allow symlinks in private gcc include dir as this can break the build
	find gcc/include*/ -type l -delete

	# Copy over the info pages.  We disabled their generation earlier, but the
	# build system only expects to install out of the build dir, not the source.  #464008
	mkdir -p gcc/doc
	local x=
	for x in "${S}"/gcc/doc/*.info* ; do
		if [[ -f ${x} ]] ; then
			cp "${x}" gcc/doc/ || die
		fi
	done

	# We remove the generated fixincludes, as they can cause things to break
	# (ncurses, openssl, etc).  We do not prevent them from being built, as
	# in the following commit which we revert:
	# https://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-x86/eclass/toolchain.eclass?r1=1.647&r2=1.648
	# This is because bsd userland needs fixedincludes to build gcc, while
	# linux does not.  Both can dispose of them afterwards.
	while read x ; do
		grep -q 'It has been auto-edited by fixincludes from' "${x}" \
			&& rm -f "${x}"
	done < <(find gcc/include*/ -name '*.h')

	# Do the 'make install' from the build directory
	S="${WORKDIR}"/build emake -j1 DESTDIR="${D}" install || die

	# Punt some tools which are really only useful while building gcc
	find "${ED}" -name install-tools -prune -type d -exec rm -rf "{}" \;
	# This one comes with binutils
	find "${ED}" -name libiberty.a -delete

	# Move the libraries to the proper location
	gcc_movelibs

	# Basic sanity check
	if ! is_crosscompile ; then
		local EXEEXT
		eval $(grep ^EXEEXT= "${WORKDIR}"/build/gcc/config.log)
		[[ -r ${D}${BINPATH}/gcc${EXEEXT} ]] || die "gcc not found in ${ED}"
	fi

	dodir /etc/env.d/gcc
	create_gcc_env_entry
	create_revdep_rebuild_entry

	# Setup the gcc_env_entry for hardened gcc 4 with minispecs
	want_minispecs && copy_minispecs_gcc_specs

	# Make sure we dont have stuff lying around that
	# can nuke multiple versions of gcc
	gcc_slot_java

	dodir /usr/bin
	cd "${D}"${BINPATH}
	# Ugh: we really need to auto-detect this list.
	#      It's constantly out of date.
	for x in cpp gcc g++ c++ gcov g77 gcj gcjh gfortran gccgo gnat* ; do
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

	# When gcc builds a crosscompiler it does not install unprefixed tools.
	# When cross-building gcc does install native tools.
	if ! is_crosscompile; then
		# Rename the main go binaries as we don't want to clobber dev-lang/go
		# when gcc-config runs. #567806
		if tc_version_is_at_least 5 && is_go ; then
			for x in go gofmt; do
				mv ${x} ${x}-${GCCMAJOR} || die
			done
		fi
	fi

	# As gcc installs object files built against bost ${CHOST} and ${CTARGET}
	# ideally we will need to strip them using different tools:
	# Using ${CHOST} tools:
	#  - "${D}${BINPATH}"
	#  - (for is_crosscompile) "${D}${HOSTLIBPATH}"
	#  - "${D}${PREFIX}/libexec/gcc/${CTARGET}/${GCC_CONFIG_VER}"
	# Using ${CTARGET} tools:
	#  - "${D}${LIBPATH}"
	# As dostrip does not specify host to override ${CHOST} tools just skip
	# non-native binary stripping.
	is_crosscompile && tc_supports_dostrip && dostrip -x "${LIBPATH}"

	cd "${S}"
	if is_crosscompile; then
		rm -rf "${ED}"/usr/share/{man,info}
		rm -rf "${D}"${DATAPATH}/{man,info}
	else
		if tc_version_is_at_least 3.0 ; then
			local cxx_mandir=$(find "${WORKDIR}/build/${CTARGET}/libstdc++-v3" -name man)
			if [[ -d ${cxx_mandir} ]] ; then
				cp -r "${cxx_mandir}"/man? "${D}${DATAPATH}"/man/
			fi
		fi
	fi

	# portage regenerates 'dir' files on it's own: bug #672408
	# Drop 'dir' files to avoid collisions.
	if [[ -f "${D}${DATAPATH}"/info/dir ]]; then
		einfo "Deleting '${D}${DATAPATH}/info/dir'"
		rm "${D}${DATAPATH}"/info/dir || die
	fi

	# prune empty dirs left behind
	find "${ED}" -depth -type d -delete 2>/dev/null

	# Rather install the script, else portage with changing $FILESDIR
	# between binary and source package borks things ....
	if ! is_crosscompile && [[ ${PN} != "kgcc64" ]] ; then
		insinto "${DATAPATH#${EPREFIX}}"
		newins "$(prefixify_ro "${FILESDIR}"/awk/fixlafiles.awk-no_gcc_la)" fixlafiles.awk || die
		exeinto "${DATAPATH#${EPREFIX}}"
		doexe "$(prefixify_ro "${FILESDIR}"/fix_libtool_files.sh)" || die
		doexe "${FILESDIR}"/c{89,99} || die
	fi

	# libstdc++.la: Delete as it doesn't add anything useful: g++ itself
	# handles linkage correctly in the dynamic & static case.  It also just
	# causes us pain: any C++ progs/libs linking with libtool will gain a
	# reference to the full libstdc++.la file which is gcc version specific.
	# libstdc++fs.la: It doesn't link against anything useful.
	# libsupc++.la: This has no dependencies.
	# libcc1.la: There is no static library, only dynamic.
	# libcc1plugin.la: Same as above, and it's loaded via dlopen.
	# libcp1plugin.la: Same as above, and it's loaded via dlopen.
	# libgomp.la: gcc itself handles linkage (libgomp.spec).
	# libgomp-plugin-*.la: Same as above, and it's an internal plugin only
	# loaded via dlopen.
	# libgfortran.la: gfortran itself handles linkage correctly in the
	# dynamic & static case (libgfortran.spec). #573302
	# libgfortranbegin.la: Same as above, and it's an internal lib.
	# libmpx.la: gcc itself handles linkage correctly (libmpx.spec).
	# libmpxwrappers.la: See above.
	# libitm.la: gcc itself handles linkage correctly (libitm.spec).
	# libvtv.la: gcc itself handles linkage correctly.
	# lib*san.la: Sanitizer linkage is handled internally by gcc, and they
	# do not support static linking. #487550 #546700
	find "${D}${LIBPATH}" \
		'(' \
			-name libstdc++.la -o \
			-name libstdc++fs.la -o \
			-name libsupc++.la -o \
			-name libcc1.la -o \
			-name libcc1plugin.la -o \
			-name libcp1plugin.la -o \
			-name 'libgomp.la' -o \
			-name 'libgomp-plugin-*.la' -o \
			-name libgfortran.la -o \
			-name libgfortranbegin.la -o \
			-name libmpx.la -o \
			-name libmpxwrappers.la -o \
			-name libitm.la -o \
			-name libvtv.la -o \
			-name 'lib*san.la' \
		')' -type f -delete

	# Use gid of 0 because some stupid ports don't have
	# the group 'root' set to gid 0.  Send to /dev/null
	# for people who are testing as non-root.
	chown -R root:0 "${D}${LIBPATH}" 2>/dev/null

	# Installing gdb pretty-printers into gdb-specific location.
	local py gdbdir=/usr/share/gdb/auto-load${LIBPATH}
	pushd "${D}${LIBPATH}" >/dev/null
	for py in $(find . -name '*-gdb.py') ; do
		local multidir=${py%/*}
		insinto "${gdbdir}/${multidir}"
		sed -i "/^libdir =/s:=.*:= '${LIBPATH}/${multidir}':" "${py}" || die #348128
		doins "${py}" || die
		rm "${py}" || die
	done
	popd >/dev/null

	# Don't scan .gox files for executable stacks - false positives
	export QA_EXECSTACK="usr/lib*/go/*/*.gox"
	export QA_WX_LOAD="usr/lib*/go/*/*.gox"

	# Disable RANDMMAP so PCH works. #301299
	if tc_version_is_at_least 4.3 ; then
		pax-mark -r "${D}${PREFIX}/libexec/gcc/${CTARGET}/${GCC_CONFIG_VER}/cc1"
		pax-mark -r "${D}${PREFIX}/libexec/gcc/${CTARGET}/${GCC_CONFIG_VER}/cc1plus"
	fi

	# Disable MPROTECT so java works. #574808
	if is_gcj ; then
		pax-mark -m "${D}${PREFIX}/libexec/gcc/${CTARGET}/${GCC_CONFIG_VER}/ecj1"
		pax-mark -m "${D}${PREFIX}/${CTARGET}/gcc-bin/${GCC_CONFIG_VER}/gij"
	fi
}

# Move around the libs to the right location.  For some reason,
# when installing gcc, it dumps internal libraries into /usr/lib
# instead of the private gcc lib path
gcc_movelibs() {
	# older versions of gcc did not support --print-multi-os-directory
	tc_version_is_at_least 3.2 || return 0

	# For non-target libs which are for CHOST and not CTARGET, we want to
	# move them to the compiler-specific CHOST internal dir.  This is stuff
	# that you want to link against when building tools rather than building
	# code to run on the target.
	if tc_version_is_at_least 5 && is_crosscompile ; then
		dodir "${HOSTLIBPATH#${EPREFIX}}"
		mv "${ED}"/usr/$(get_libdir)/libcc1* "${D}${HOSTLIBPATH}" || die
	fi

	# For all the libs that are built for CTARGET, move them into the
	# compiler-specific CTARGET internal dir.
	local x multiarg removedirs=""
	for multiarg in $($(XGCC) -print-multi-lib) ; do
		multiarg=${multiarg#*;}
		multiarg=${multiarg//@/ -}

		local OS_MULTIDIR=$($(XGCC) ${multiarg} --print-multi-os-directory)
		local MULTIDIR=$($(XGCC) ${multiarg} --print-multi-directory)
		local TODIR="${D}${LIBPATH}"/${MULTIDIR}
		local FROMDIR=

		[[ -d ${TODIR} ]] || mkdir -p ${TODIR}

		for FROMDIR in \
			"${LIBPATH}"/${OS_MULTIDIR} \
			"${LIBPATH}"/../${MULTIDIR} \
			"${PREFIX}"/lib/${OS_MULTIDIR} \
			"${PREFIX}"/${CTARGET}/lib/${OS_MULTIDIR}
		do
			removedirs="${removedirs} ${FROMDIR}"
			FROMDIR=${D}${FROMDIR}
			if [[ ${FROMDIR} != "${TODIR}" && -d ${FROMDIR} ]] ; then
				local files=$(find "${FROMDIR}" -maxdepth 1 ! -type d 2>/dev/null)
				if [[ -n ${files} ]] ; then
					mv ${files} "${TODIR}" || die
				fi
			fi
		done
		fix_libtool_libdir_paths "${LIBPATH}/${MULTIDIR}"

		# SLOT up libgcj.pc if it's available (and let gcc-config worry about links)
		FROMDIR="${PREFIX}/lib/${OS_MULTIDIR}"
		for x in "${D}${FROMDIR}"/pkgconfig/libgcj*.pc ; do
			[[ -f ${x} ]] || continue
			sed -i "/^libdir=/s:=.*:=${LIBPATH}/${MULTIDIR}:" "${x}" || die
			mv "${x}" "${D}${FROMDIR}"/pkgconfig/libgcj-${GCC_PV}.pc || die
		done
	done

	# We remove directories separately to avoid this case:
	#	mv SRC/lib/../lib/*.o DEST
	#	rmdir SRC/lib/../lib/
	#	mv SRC/lib/../lib32/*.o DEST  # Bork
	for FROMDIR in ${removedirs} ; do
		rmdir "${D}"${FROMDIR} >& /dev/null
	done
	find -depth "${ED}" -type d -exec rmdir {} + >& /dev/null
}

# make sure the libtool archives have libdir set to where they actually
# -are-, and not where they -used- to be.  also, any dependencies we have
# on our own .la files need to be updated.
fix_libtool_libdir_paths() {
	local libpath="$1"

	pushd "${D}" >/dev/null

	pushd "./${libpath}" >/dev/null
	local dir="${PWD#${D%/}}"
	local allarchives=$(echo *.la)
	allarchives="\(${allarchives// /\\|}\)"
	popd >/dev/null

	# The libdir might not have any .la files. #548782
	find "./${dir}" -maxdepth 1 -name '*.la' \
		-exec sed -i -e "/^libdir=/s:=.*:='${dir}':" {} + || die
	# Would be nice to combine these, but -maxdepth can not be specified
	# on sub-expressions.
	find "./${PREFIX}"/lib* -maxdepth 3 -name '*.la' \
		-exec sed -i -e "/^dependency_libs=/s:/[^ ]*/${allarchives}:${libpath}/\1:g" {} + || die
	find "./${dir}/" -maxdepth 1 -name '*.la' \
		-exec sed -i -e "/^dependency_libs=/s:/[^ ]*/${allarchives}:${libpath}/\1:g" {} + || die

	popd >/dev/null
}

create_gcc_env_entry() {
	dodir /etc/env.d/gcc
	local gcc_envd_base="/etc/env.d/gcc/${CTARGET}-${GCC_CONFIG_VER}"

	local gcc_specs_file
	local gcc_envd_file="${ED}${gcc_envd_base}"
	if [[ -z $1 ]] ; then
		# I'm leaving the following commented out to remind me that it
		# was an insanely -bad- idea. Stuff broke. GCC_SPECS isnt unset
		# on chroot or in non-toolchain.eclass gcc ebuilds!
		#gcc_specs_file="${LIBPATH}/specs"
		gcc_specs_file=""
	else
		gcc_envd_file+="-$1"
		gcc_specs_file="${LIBPATH}/$1.specs"
	fi

	# We want to list the default ABI's LIBPATH first so libtool
	# searches that directory first.  This is a temporary
	# workaround for libtool being stupid and using .la's from
	# conflicting ABIs by using the first one in the search path
	local ldpaths mosdirs
	if tc_version_is_at_least 3.2 ; then
		local mdir mosdir abi ldpath
		for abi in $(get_all_abis TARGET) ; do
			mdir=$($(XGCC) $(get_abi_CFLAGS ${abi}) --print-multi-directory)
			ldpath=${LIBPATH}
			[[ ${mdir} != "." ]] && ldpath+="/${mdir}"
			ldpaths="${ldpath}${ldpaths:+:${ldpaths}}"

			mosdir=$($(XGCC) $(get_abi_CFLAGS ${abi}) -print-multi-os-directory)
			mosdirs="${mosdir}${mosdirs:+:${mosdirs}}"
		done
	else
		# Older gcc's didn't do multilib, so logic is simple.
		ldpaths=${LIBPATH}
	fi

	cat <<-EOF > ${gcc_envd_file}
	GCC_PATH="${BINPATH}"
	LDPATH="${ldpaths}"
	MANPATH="${DATAPATH}/man"
	INFOPATH="${DATAPATH}/info"
	STDCXX_INCDIR="${STDCXX_INCDIR##*/}"
	CTARGET="${CTARGET}"
	GCC_SPECS="${gcc_specs_file}"
	MULTIOSDIRS="${mosdirs}"
	EOF
}

create_revdep_rebuild_entry() {
	local revdep_rebuild_base="/etc/revdep-rebuild/05cross-${CTARGET}-${GCC_CONFIG_VER}"
	local revdep_rebuild_file="${ED}${revdep_rebuild_base}"

	is_crosscompile || return 0

	dodir /etc/revdep-rebuild
	cat <<-EOF > "${revdep_rebuild_file}"
	# Generated by ${CATEGORY}/${PF}
	# Ignore libraries built for ${CTARGET}, https://bugs.gentoo.org/692844.
	SEARCH_DIRS_MASK="${LIBPATH}"
	EOF
}

copy_minispecs_gcc_specs() {
	# on gcc 6 we don't need minispecs
	if tc_version_is_at_least 6.0 ; then
		return 0
	fi

	# setup the hardenedno* specs files and the vanilla specs file.
	if hardened_gcc_works ; then
		create_gcc_env_entry hardenednopiessp
	fi
	if hardened_gcc_works pie ; then
		create_gcc_env_entry hardenednopie
	fi
	if hardened_gcc_works ssp ; then
		create_gcc_env_entry hardenednossp
	fi
	create_gcc_env_entry vanilla
	insinto ${LIBPATH#${EPREFIX}}
	doins "${WORKDIR}"/specs/*.specs || die "failed to install specs"
	# Build system specs file which, if it exists, must be a complete set of
	# specs as it completely and unconditionally overrides the builtin specs.
	if ! tc_version_is_at_least 4.4 ; then
		$(XGCC) -dumpspecs > "${WORKDIR}"/specs/specs
		cat "${WORKDIR}"/build.specs >> "${WORKDIR}"/specs/specs
		doins "${WORKDIR}"/specs/specs || die "failed to install the specs file"
	fi
}

gcc_slot_java() {
	local x

	# Move Java headers to compiler-specific dir
	for x in "${D}${PREFIX}"/include/gc*.h "${D}${PREFIX}"/include/j*.h ; do
		[[ -f ${x} ]] && mv -f "${x}" "${D}${LIBPATH}"/include/
	done
	for x in gcj gnu java javax org ; do
		if [[ -d ${D}${PREFIX}/include/${x} ]] ; then
			dodir /${LIBPATH#${EPREFIX}}/include/${x}
			mv -f "${D}${PREFIX}"/include/${x}/* "${D}${LIBPATH}"/include/${x}/
			rm -rf "${D}${PREFIX}"/include/${x}
		fi
	done

	if [[ -d ${D}${PREFIX}/lib/security ]] || [[ -d ${D}${PREFIX}/$(get_libdir)/security ]] ; then
		dodir /${LIBPATH#${EPREFIX}}/security
		mv -f "${D}${PREFIX}"/lib*/security/* "${D}${LIBPATH}"/security
		rm -rf "${D}${PREFIX}"/lib*/security
	fi

	# Move random gcj files to compiler-specific directories
	for x in libgcj.spec logging.properties ; do
		x="${D}${PREFIX}/lib/${x}"
		[[ -f ${x} ]] && mv -f "${x}" "${D}${LIBPATH}"/
	done

	# Rename jar because it could clash with Kaffe's jar if this gcc is
	# primary compiler (aka don't have the -<version> extension)
	cd "${D}${BINPATH}"
	[[ -f jar ]] && mv -f jar gcj-jar
}

#---->> pkg_post* <<----

toolchain_pkg_postinst() {
	do_gcc_config
	if [[ ! ${ROOT%/} && -f ${EPREFIX}/usr/share/eselect/modules/compiler-shadow.eselect ]] ; then
		eselect compiler-shadow update all
	fi

	if ! is_crosscompile && [[ ${PN} != "kgcc64" ]] ; then
		echo
		ewarn "If you have issues with packages unable to locate libstdc++.la,"
		ewarn "then try running 'fix_libtool_files.sh' on the old gcc versions."
		echo
		ewarn "You might want to review the GCC upgrade guide when moving between"
		ewarn "major versions (like 4.2 to 4.3):"
		ewarn "https://wiki.gentoo.org/wiki/Upgrading_GCC"
		echo

		# Clean up old paths
		rm -f "${EROOT%/}"/*/rcscripts/awk/fixlafiles.awk "${EROOT%/}"/sbin/fix_libtool_files.sh
		rmdir "${EROOT%/}"/*/rcscripts{/awk,} 2>/dev/null

		mkdir -p "${EROOT%/}"/usr/{share/gcc-data,sbin,bin}
		# DATAPATH has EPREFIX already, use ROOT with it
		cp "${ROOT%/}${DATAPATH}"/fixlafiles.awk "${EROOT%/}"/usr/share/gcc-data/ || die
		cp "${ROOT%/}${DATAPATH}"/fix_libtool_files.sh "${EROOT%/}"/usr/sbin/ || die

		# Since these aren't critical files and portage sucks with
		# handling of binpkgs, don't require these to be found
		cp "${ROOT%/}${DATAPATH}"/c{89,99} "${EROOT%/}"/usr/bin/ 2>/dev/null
	fi

	if [[ -n ${PRERELEASE}${SNAPSHOT} ]] ; then
		einfo "This GCC ebuild is provided for your convenience, and the use"
		einfo "of this compiler is not supported by the Gentoo Developers."
		einfo "Please report bugs to upstream at http://gcc.gnu.org/bugzilla/"
	fi
}

toolchain_pkg_postrm() {
	do_gcc_config
	if [[ ! ${ROOT%/} && -f ${EPREFIX}/usr/share/eselect/modules/compiler-shadow.eselect ]] ; then
		eselect compiler-shadow clean all
	fi

	# to make our lives easier (and saner), we do the fix_libtool stuff here.
	# rather than checking SLOT's and trying in upgrade paths, we just see if
	# the common libstdc++.la exists in the ${LIBPATH} of the gcc that we are
	# unmerging.  if it does, that means this was a simple re-emerge.

	# clean up the cruft left behind by cross-compilers
	if is_crosscompile ; then
		if [[ -z $(ls "${EROOT%/}"/etc/env.d/gcc/${CTARGET}* 2>/dev/null) ]] ; then
			einfo "Removing last cross-compiler instance. Deleting dangling symlinks."
			rm -f "${EROOT%/}"/etc/env.d/gcc/config-${CTARGET}
			rm -f "${EROOT%/}"/etc/env.d/??gcc-${CTARGET}
			rm -f "${EROOT%/}"/usr/bin/${CTARGET}-{gcc,{g,c}++}{,32,64}
		fi
		return 0
	fi

	# ROOT isnt handled by the script
	[[ ${ROOT%/} ]] && return 0

	if [[ ! -e ${LIBPATH}/libstdc++.so ]] ; then
		einfo "Running 'fix_libtool_files.sh ${GCC_RELEASE_VER}'"
		fix_libtool_files.sh ${GCC_RELEASE_VER}
	fi

	return 0
}

do_gcc_config() {
	if ! should_we_gcc_config ; then
		gcc-config --use-old --force
		return 0
	fi

	local current_gcc_config target

	current_gcc_config=$(gcc-config -c ${CTARGET} 2>/dev/null)
	if [[ -n ${current_gcc_config} ]] ; then
		local current_specs use_specs
		# figure out which specs-specific config is active
		current_specs=$(gcc-config -S ${current_gcc_config} | awk '{print $3}')
		[[ -n ${current_specs} ]] && use_specs=-${current_specs}

		if [[ -n ${use_specs} ]] && \
		   [[ ! -e ${EROOT%/}/etc/env.d/gcc/${CTARGET}-${GCC_CONFIG_VER}${use_specs} ]]
		then
			ewarn "The currently selected specs-specific gcc config,"
			ewarn "${current_specs}, doesn't exist anymore. This is usually"
			ewarn "due to enabling/disabling hardened or switching to a version"
			ewarn "of gcc that doesnt create multiple specs files. The default"
			ewarn "config will be used, and the previous preference forgotten."
			use_specs=""
		fi

		target="${CTARGET}-${GCC_CONFIG_VER}${use_specs}"
	else
		# The curent target is invalid.  Attempt to switch to a valid one.
		# Blindly pick the latest version.  #529608
		# TODO: Should update gcc-config to accept `-l ${CTARGET}` rather than
		# doing a partial grep like this.
		target=$(gcc-config -l 2>/dev/null | grep " ${CTARGET}-[0-9]" | tail -1 | awk '{print $2}')
	fi

	gcc-config "${target}"
}

should_we_gcc_config() {
	# if the current config is invalid, we definitely want a new one
	# Note: due to bash quirkiness, the following must not be 1 line
	local curr_config
	curr_config=$(gcc-config -c ${CTARGET} 2>&1) || return 0

	# if the previously selected config has the same major.minor (branch) as
	# the version we are installing, then it will probably be uninstalled
	# for being in the same SLOT, make sure we run gcc-config.
	local curr_config_ver=$(gcc-config -S ${curr_config} | awk '{print $2}')

	local curr_branch_ver=$(ver_cut 1-2 ${curr_config_ver})

	if [[ ${curr_branch_ver} == ${GCC_BRANCH_VER} ]] ; then
		return 0
	else
		# if we're installing a genuinely different compiler version,
		# we should probably tell the user -how- to switch to the new
		# gcc version, since we're not going to do it for him/her.
		# We don't want to switch from say gcc-3.3 to gcc-3.4 right in
		# the middle of an emerge operation (like an 'emerge -e world'
		# which could install multiple gcc versions).
		# Only warn if we're installing a pkg as we might be called from
		# the pkg_{pre,post}rm steps.  #446830
		if [[ ${EBUILD_PHASE} == *"inst" ]] ; then
			einfo "The current gcc config appears valid, so it will not be"
			einfo "automatically switched for you.  If you would like to"
			einfo "switch to the newly installed gcc version, do the"
			einfo "following:"
			echo
			einfo "gcc-config ${CTARGET}-${GCC_CONFIG_VER}"
			einfo "source /etc/profile"
			echo
		fi
		return 1
	fi
}

#---->> support and misc functions <<----

# This is to make sure we don't accidentally try to enable support for a
# language that doesnt exist. GCC 3.4 supports f77, while 4.0 supports f95, etc.
#
# Also add a hook so special ebuilds (kgcc64) can control which languages
# exactly get enabled
gcc-lang-supported() {
	grep ^language=\"${1}\" "${S}"/gcc/*/config-lang.in > /dev/null || return 1
	[[ -z ${TOOLCHAIN_ALLOWED_LANGS} ]] && return 0
	has $1 ${TOOLCHAIN_ALLOWED_LANGS}
}

is_ada() {
	gcc-lang-supported ada || return 1
	use_if_iuse ada
}

is_cxx() {
	gcc-lang-supported 'c++' || return 1
	use_if_iuse cxx
}

is_d() {
	gcc-lang-supported d || return 1
	use_if_iuse d
}

is_f77() {
	gcc-lang-supported f77 || return 1
	use_if_iuse fortran
}

is_f95() {
	gcc-lang-supported f95 || return 1
	use_if_iuse fortran
}

is_fortran() {
	gcc-lang-supported fortran || return 1
	use_if_iuse fortran
}

is_gcj() {
	gcc-lang-supported java || return 1
	use_if_iuse cxx && use_if_iuse gcj
}

is_go() {
	gcc-lang-supported go || return 1
	use_if_iuse cxx && use_if_iuse go
}

is_jit() {
	gcc-lang-supported jit || return 1
	# cross-compiler does not really support jit as it has
	# to generate code for a target. On target like avr
	# libgcclit.so can't link at all: bug #594572
	is_crosscompile && return 1
	use_if_iuse jit
}

is_multilib() {
	tc_version_is_at_least 3 || return 1
	use_if_iuse multilib
}

is_objc() {
	gcc-lang-supported objc || return 1
	use_if_iuse objc
}

is_objcxx() {
	gcc-lang-supported 'obj-c++' || return 1
	use_if_iuse cxx && use_if_iuse objc++
}

# Grab a variable from the build system (taken from linux-info.eclass)
get_make_var() {
	local var=$1 makefile=${2:-${WORKDIR}/build/Makefile}
	echo -e "e:\\n\\t@echo \$(${var})\\ninclude ${makefile}" | \
		r=${makefile%/*} emake --no-print-directory -s -f - 2>/dev/null
}

XGCC() { get_make_var GCC_FOR_TARGET ; }

# The gentoo piessp patches allow for 3 configurations:
# 1) PIE+SSP by default
# 2) PIE by default
# 3) SSP by default
hardened_gcc_works() {
	if [[ $1 == "pie" ]] ; then
		# $gcc_cv_ld_pie is unreliable as it simply take the output of
		# `ld --help | grep -- -pie`, that reports the option in all cases, also if
		# the loader doesn't actually load the resulting executables.
		# To avoid breakage, blacklist FreeBSD here at least
		[[ ${CTARGET} == *-freebsd* ]] && return 1

		want_pie || return 1
		use_if_iuse nopie && return 1
		hardened_gcc_is_stable pie
		return $?
	elif [[ $1 == "ssp" ]] ; then
		[[ -n ${SPECS_VER} ]] || return 1
		use_if_iuse nossp && return 1
		hardened_gcc_is_stable ssp
		return $?
	else
		# laziness ;)
		hardened_gcc_works pie || return 1
		hardened_gcc_works ssp || return 1
		return 0
	fi
}

hardened_gcc_is_stable() {
	local tocheck
	if [[ $1 == "pie" ]] ; then
		if [[ ${CTARGET} == *-uclibc* ]] ; then
			tocheck=${PIE_UCLIBC_STABLE}
		else
			tocheck=${PIE_GLIBC_STABLE}
		fi
	elif [[ $1 == "ssp" ]] ; then
		if [[ ${CTARGET} == *-uclibc* ]] ; then
			tocheck=${SSP_UCLIBC_STABLE}
		elif  [[ ${CTARGET} == *-gnu* ]] ; then
			tocheck=${SSP_STABLE}
		fi
	else
		die "hardened_gcc_stable needs to be called with pie or ssp"
	fi

	has $(tc-arch) ${tocheck} && return 0
	return 1
}

want_minispecs() {
	# on gcc 6 we don't need minispecs
	if tc_version_is_at_least 6.0 ; then
		return 0
	fi
	if tc_version_is_at_least 4.3.2 && use_if_iuse hardened ; then
		if ! want_pie ; then
			ewarn "PIE_VER or SPECS_VER is not defined in the GCC ebuild."
		elif use vanilla ; then
			ewarn "You will not get hardened features if you have the vanilla USE-flag."
		elif use_if_iuse nopie && use_if_iuse nossp ; then
			ewarn "You will not get hardened features if you have the nopie and nossp USE-flag."
		elif ! hardened_gcc_works ; then
			ewarn "Your $(tc-arch) arch is not supported."
		else
			return 0
		fi
		ewarn "Hope you know what you are doing. Hardened will not work."
		return 0
	fi
	return 1
}

want_pie() {
	! use_if_iuse hardened && [[ -n ${PIE_VER} ]] && use_if_iuse nopie && return 1
	[[ -n ${PIE_VER} ]] && [[ -n ${SPECS_VER} ]] && return 0
	tc_version_is_at_least 4.3.2 && return 1
	[[ -z ${PIE_VER} ]] && return 1
	use_if_iuse nopie || return 0
	return 1
}

has toolchain_death_notice ${EBUILD_DEATH_HOOKS} || EBUILD_DEATH_HOOKS+=" toolchain_death_notice"
toolchain_death_notice() {
	if [[ -e "${WORKDIR}"/build ]] ; then
		pushd "${WORKDIR}"/build >/dev/null
		(echo '' | $(tc-getCC ${CTARGET}) ${CFLAGS} -v -E - 2>&1) > gccinfo.log
		[[ -e "${T}"/build.log ]] && cp "${T}"/build.log .
		tar jcf "${WORKDIR}"/gcc-build-logs.tar.bz2 \
			gccinfo.log build.log $(find -name config.log)
		rm gccinfo.log build.log
		eerror
		eerror "Please include ${WORKDIR}/gcc-build-logs.tar.bz2 in your bug report."
		eerror
		popd >/dev/null
	fi
}

# Note [implicitly enabled flags]
# -------------------------------
# Usually configure-based packages handle explicit feature requests
# like
#     ./configure --enable-foo
# as explicit request to check for support of 'foo' and bail out at
# configure time.
#
# GCC does not follow this pattern and instead overrides autodetection
# of the feature and enables it unconditionally.
# See bugs:
#    https://gcc.gnu.org/PR85663 (libsanitizer on mips)
#    https://bugs.gentoo.org/661252 (libvtv on powerpc64)
#
# Thus safer way to enable/disable the feature is to rely on implicit
# enabled-by-default state:
#    econf $(usex foo '' --disable-foo)
