# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: toolchain.eclass
# @MAINTAINER:
# Toolchain Ninjas <toolchain@gentoo.org>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Common code for sys-devel/gcc ebuilds
# @DESCRIPTION:
# Common code for sys-devel/gcc ebuilds (and occasionally GCC forks, like
# GNAT for Ada). If not building GCC itself, please use toolchain-funcs.eclass
# instead.

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_TOOLCHAIN_ECLASS} ]]; then
_TOOLCHAIN_ECLASS=1

DESCRIPTION="The GNU Compiler Collection"
HOMEPAGE="https://gcc.gnu.org/"

inherit edo flag-o-matic gnuconfig libtool multilib pax-utils python-any-r1 toolchain-funcs prefix

tc_is_live() {
	[[ ${PV} == *9999* ]]
}

if tc_is_live ; then
	EGIT_REPO_URI="https://gcc.gnu.org/git/gcc.git https://github.com/gcc-mirror/gcc"
	# Naming style:
	# gcc-10.1.0_pre9999 -> gcc-10-branch
	#  Note that the micro version is required or lots of stuff will break.
	#  To checkout master set gcc_LIVE_BRANCH="master" in the ebuild before
	#  inheriting this eclass.
	EGIT_BRANCH="releases/${PN}-${PV%.?.?_pre9999}"
	EGIT_BRANCH=${EGIT_BRANCH//./_}
	inherit git-r3
elif [[ -n ${TOOLCHAIN_USE_GIT_PATCHES} ]] ; then
	inherit git-r3
fi

FEATURES=${FEATURES/multilib-strict/}

#---->> globals <<----

export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} = ${CHOST} ]] ; then
	if [[ ${CATEGORY} == cross-* ]] ; then
		export CTARGET=${CATEGORY#cross-}
	fi
fi
: "${TARGET_ABI:=${ABI}}"
: "${TARGET_MULTILIB_ABIS:=${MULTILIB_ABIS}}"
: "${TARGET_DEFAULT_ABI:=${DEFAULT_ABI}}"

is_crosscompile() {
	[[ ${CHOST} != ${CTARGET} ]]
}

# @FUNCTION: tc_version_is_at_least
# @USAGE: ver1 [ver2]
# @DESCRIPTION:
# General purpose version check. Without a second argument, matches
# up to minor version (x.x.x).
tc_version_is_at_least() {
	ver_test "${2:-${GCC_RELEASE_VER}}" -ge "$1"
}

# @FUNCTION: tc_version_is_between
# @USAGE: ver1 ver2
# @DESCRIPTION:
# General purpose version range check.
# Note that it matches up to but NOT including the second version
tc_version_is_between() {
	tc_version_is_at_least "${1}" && ! tc_version_is_at_least "${2}"
}

# @ECLASS_VARIABLE: TOOLCHAIN_GCC_PV
# @DEFAULT_UNSET
# @DESCRIPTION:
# Used to override GCC version. Useful for e.g. live ebuilds or snapshots.
# Defaults to ${PV}.

# @ECLASS_VARIABLE: TOOLCHAIN_GCC_VALIDATE_FAILURES_VERSION
# @DESCRIPTION:
# Version of test comparison script (validate_failures.py) to use.
: "${GCC_VALIDATE_FAILURES_VERSION:=a447cd6dee206facb66720bdacf0c765a8b09f33}"

# @ECLASS_VARIABLE: TOOLCHAIN_USE_GIT_PATCHES
# @DEFAULT_UNSET
# @DESCRIPTION:
# Used to force fetching patches from git. Useful for non-released versions
# of GCC where we don't want to keep creating patchset tarballs for a new
# release series (e.g. suppose 12.0 just got released, then adding snapshots
# for 13.0, we don't want to create new patchsets for every single 13.0 snapshot,
# so just grab patches from git each time if this variable is set).

# @ECLASS_VARIABLE: GCC_TESTS_COMPARISON_DIR
# @USER_VARIABLE
# @DESCRIPTION:
# Source of previous GCC test results and location to store new results.
: "${GCC_TESTS_COMPARISON_DIR:=${BROOT}/var/cache/gcc/testresults/${CHOST}}"

# @ECLASS_VARIABLE: GCC_TESTS_COMPARISON_SLOT
# @USER_VARIABLE
# @DESCRIPTION:
# Slot to compare test results with. Defaults to current slot.
: "${GCC_TESTS_COMPARISON_SLOT:=${SLOT}}"

# @ECLASS_VARIABLE: GCC_TESTS_IGNORE_NO_BASELINE
# @DEFAULT_UNSET
# @USER_VARIABLE
# @DESCRIPTION:
# Ignore missing baseline/reference data and create new baseline.
: "${GCC_TESTS_IGNORE_NO_BASELINE:=}"

# @ECLASS_VARIABLE: GCC_TESTS_REGEN_BASELINE
# @DEFAULT_UNSET
# @USER_VARIABLE
# @DESCRIPTION:
# Ignore baseline/reference data and create new baseline.
: "${GCC_TESTS_REGEN_BASELINE:=}"

# @ECLASS_VARIABLE: GCC_TESTS_CHECK_TARGET
# @USER_VARIABLE
# @DESCRIPTION:
# Defaults to 'check'. Allows choosing a different test target, e.g.
# 'test-gcc' (https://gcc.gnu.org/install/test.html).
: "${GCC_TESTS_CHECK_TARGET:=check}"

# @ECLASS_VARIABLE: GCC_TESTS_RUNTESTFLAGS
# @DEFAULT_UNSET
# @USER_VARIABLE
# @DESCRIPTION:
# Extra options to pass to DejaGnu as RUNTESTFLAGS.
: "${GCC_TESTS_RUNTESTFLAGS:=}"

# @ECLASS_VARIABLE: TOOLCHAIN_PATCH_DEV
# @DEFAULT_UNSET
# @DESCRIPTION:
# Indicate the developer who hosts the patchset for an ebuild.

# @ECLASS_VARIABLE: GCC_PV
# @INTERNAL
# @DESCRIPTION:
# Internal variable representing (spoofed) GCC version.
GCC_PV=${TOOLCHAIN_GCC_PV:-${PV}}

# @ECLASS_VARIABLE: GCC_PVR
# @INTERNAL
# @DESCRIPTION:
# Full GCC version including revision.
GCC_PVR=${GCC_PV}
[[ ${PR} != "r0" ]] && GCC_PVR=${GCC_PVR}-${PR}

# @ECLASS_VARIABLE: GCC_RELEASE_VER
# @INTERNAL
# @DESCRIPTION:
# GCC_RELEASE_VER must always match 'gcc/BASE-VER' value.
# It's an internal representation of gcc version used for:
# - versioned paths on disk
# - 'gcc -dumpversion' output. Must always match <digit>.<digit>.<digit>.
GCC_RELEASE_VER=$(ver_cut 1-3 ${GCC_PV})

# @ECLASS_VARIABLE: GCC_BRANCH_VER
# @INTERNAL
# @DESCRIPTION:
# GCC branch version.
GCC_BRANCH_VER=$(ver_cut 1-2 ${GCC_PV})
# @ECLASS_VARIABLE: GCCMAJOR
# @INTERNAL
# @DESCRIPTION:
# Major GCC version.
GCCMAJOR=$(ver_cut 1 ${GCC_PV})
# @ECLASS_VARIABLE: GCCMINOR
# @INTERNAL
# @DESCRIPTION:
# Minor GCC version.
GCCMINOR=$(ver_cut 2 ${GCC_PV})
# @ECLASS_VARIABLE: GCCMICRO
# @INTERNAL
# @DESCRIPTION:
# GCC micro version.
GCCMICRO=$(ver_cut 3 ${GCC_PV})
# @ECLASS_VARIABLE: GCC_RUN_FIXINCLUDES
# @INTERNAL
# @DESCRIPTION:
# Controls whether fixincludes should be used.
GCC_RUN_FIXINCLUDES=0

tc_use_major_version_only() {
	local use_major_version_only=0

	if ! tc_version_is_at_least 10 ; then
		return 1
	fi

	if [[ ${GCCMAJOR} -eq 10 ]] && ver_test ${PV} -ge 10.4.1_p20220929 ; then
		use_major_version_only=1
	elif [[ ${GCCMAJOR} -eq 11 ]] && ver_test ${PV} -ge 11.3.1_p20220930 ; then
		use_major_version_only=1
	elif [[ ${GCCMAJOR} -eq 12 ]] && ver_test ${PV} -ge 12.2.1_p20221001 ; then
		use_major_version_only=1
	elif [[ ${GCCMAJOR} -eq 13 ]] && ver_test ${PV} -ge 13.0.0_pre20221002 ; then
		use_major_version_only=1
	elif [[ ${GCCMAJOR} -gt 13 ]] ; then
		use_major_version_only=1
	fi

	if [[ ${use_major_version_only} -eq 1 ]] ; then
		return 0
	fi

	return 1
}

# @ECLASS_VARIABLE: GCC_CONFIG_VER
# @INTERNAL
# @DESCRIPTION:
# Ideally this variable should allow for custom gentoo versioning
# of binary and gcc-config names not directly tied to upstream
# versioning. In practice it's hard to untangle from gcc/BASE-VER
# (GCC_RELEASE_VER) value.
if tc_use_major_version_only ; then
	GCC_CONFIG_VER=${GCCMAJOR}
else
	GCC_CONFIG_VER=${GCC_RELEASE_VER}
fi

# Pre-release support. Versioning schema:
# 1.0.0_pre9999: live ebuild
# 1.2.3_pYYYYMMDD (or 1.2.3_preYYYYMMDD for unreleased major versions): weekly snapshots
# 1.2.3_rcYYYYMMDD: release candidates
if [[ ${GCC_PV} == *_pre* ]] ; then
	# Weekly snapshots
	SNAPSHOT=${GCCMAJOR}-${GCC_PV##*_pre}
elif [[ ${GCC_PV} == *_p* ]] ; then
	# Weekly snapshots
	SNAPSHOT=${GCCMAJOR}-${GCC_PV##*_p}
elif [[ ${GCC_PV} == *_rc* ]] ; then
	# Release candidates
	SNAPSHOT=${GCC_PV%_rc*}-RC-${GCC_PV##*_rc}
fi

# Require minimum gcc version to simplify assumptions.
# Normally we would require gcc-6+ (based on sys-devel/gcc)
# but we still have sys-devel/gcc-apple-4.2.1_p5666.
tc_version_is_at_least 8 || die "${ECLASS}: ${GCC_RELEASE_VER} is too old."

PREFIX=${TOOLCHAIN_PREFIX:-${EPREFIX}/usr}

LIBPATH=${TOOLCHAIN_LIBPATH:-${PREFIX}/lib/gcc/${CTARGET}/${GCC_CONFIG_VER}}
INCLUDEPATH=${TOOLCHAIN_INCLUDEPATH:-${LIBPATH}/include}

if is_crosscompile ; then
	BINPATH=${TOOLCHAIN_BINPATH:-${PREFIX}/${CHOST}/${CTARGET}/gcc-bin/${GCC_CONFIG_VER}}
	HOSTLIBPATH=${PREFIX}/${CHOST}/${CTARGET}/lib/${GCC_CONFIG_VER}
else
	BINPATH=${TOOLCHAIN_BINPATH:-${PREFIX}/${CTARGET}/gcc-bin/${GCC_CONFIG_VER}}
fi

DATAPATH=${TOOLCHAIN_DATAPATH:-${PREFIX}/share/gcc-data/${CTARGET}/${GCC_CONFIG_VER}}

# Don't install in /usr/include/g++-v3/, but instead to gcc's internal directory.
# We will handle /usr/include/g++-v3/ with gcc-config ...
STDCXX_INCDIR=${TOOLCHAIN_STDCXX_INCDIR:-${LIBPATH}/include/g++-v${GCC_BRANCH_VER/\.*/}}

#---->> LICENSE+SLOT+IUSE logic <<----

LICENSE="GPL-3+ LGPL-3+ || ( GPL-3+ libgcc libstdc++ gcc-runtime-library-exception-3.1 ) FDL-1.3+"
IUSE="test vanilla +nls"
RESTRICT="!test? ( test )"

TC_FEATURES=()

tc_has_feature() {
	has "$1" "${TC_FEATURES[@]}"
}

if [[ ${PN} != kgcc64 && ${PN} != gcc-* ]] ; then
	IUSE+=" debug +cxx"
	IUSE+=" +fortran" TC_FEATURES+=( fortran )
	IUSE+=" doc hardened multilib objc"
	IUSE+=" pgo"
	IUSE+=" objc-gc" TC_FEATURES+=( objc-gc )
	IUSE+=" libssp objc++"

	# Stop forcing openmp on by default in the eclass. Gradually phase it out.
	# See bug #890999.
	if tc_version_is_at_least 13.0.0_pre20221218 ; then
		IUSE+=" openmp"
	else
		IUSE+=" +openmp"
	fi

	IUSE+=" fixed-point"
	IUSE+=" go"
	IUSE+=" +sanitize"  TC_FEATURES+=( sanitize )
	IUSE+=" graphite" TC_FEATURES+=( graphite )
	IUSE+=" ada" TC_FEATURES+=( ada )
	IUSE+=" vtv"
	IUSE+=" jit"
	IUSE+=" +pie +ssp pch"

	IUSE+=" systemtap" TC_FEATURES+=( systemtap )

	tc_version_is_at_least 9.0 && IUSE+=" d" TC_FEATURES+=( d )
	tc_version_is_at_least 9.1 && IUSE+=" lto"
	tc_version_is_at_least 10 && IUSE+=" cet"
	tc_version_is_at_least 10 && IUSE+=" zstd" TC_FEATURES+=( zstd )
	tc_version_is_at_least 11 && IUSE+=" valgrind" TC_FEATURES+=( valgrind )
	tc_version_is_at_least 11 && IUSE+=" custom-cflags"
	tc_version_is_at_least 12 && IUSE+=" ieee-long-double"
	tc_version_is_at_least 12.2.1_p20221203 ${PV} && IUSE+=" default-znow"
	tc_version_is_at_least 12.2.1_p20221203 ${PV} && IUSE+=" default-stack-clash-protection"
	tc_version_is_at_least 13.0.0_pre20221218 ${PV} && IUSE+=" modula2"
	# See https://gcc.gnu.org/pipermail/gcc-patches/2023-April/615944.html
	# and https://rust-gcc.github.io/2023/04/24/gccrs-and-gcc13-release.html for why
	# it was disabled in 13.
	tc_version_is_at_least 14.0.0_pre20230423 ${PV} && IUSE+=" rust" TC_FEATURES+=( rust )
fi

if tc_version_is_at_least 10; then
	# Note: currently we pull in releases, snapshots and
	# git versions into the same SLOT.
	SLOT="${GCCMAJOR}"
else
	SLOT="${GCC_CONFIG_VER}"
fi

#---->> DEPEND <<----

RDEPEND="
	sys-libs/zlib
	virtual/libiconv
	nls? ( virtual/libintl )
"

GMP_MPFR_DEPS=">=dev-libs/gmp-4.3.2:0= >=dev-libs/mpfr-2.4.2:0="
RDEPEND+=" ${GMP_MPFR_DEPS}"
RDEPEND+=" >=dev-libs/mpc-0.8.1:0="

if tc_has_feature objc-gc ; then
	RDEPEND+=" objc-gc? ( >=dev-libs/boehm-gc-7.4.2 )"
fi

if tc_has_feature graphite ; then
	RDEPEND+=" graphite? ( >=dev-libs/isl-0.14:0= )"
fi

BDEPEND="
	app-alternatives/yacc
	>=sys-devel/flex-2.5.4
	nls? ( sys-devel/gettext )
	test? (
		${PYTHON_DEPS}
		>=dev-util/dejagnu-1.4.4
		>=sys-devel/autogen-5.5.4
	)
"
DEPEND="${RDEPEND}"

if [[ ${PN} == gcc && ${PV} == *_p* ]] ; then
	# Snapshots don't contain info pages.
	# If they start to, adjust gcc_cv_prog_makeinfo_modern logic in toolchain_src_configure.
	# Needed unless/until https://gcc.gnu.org/PR106899 is fixed
	BDEPEND+=" sys-apps/texinfo"
fi

if tc_has_feature sanitize ; then
	# libsanitizer relies on 'crypt.h' to be present
	# on target. glibc user to provide it unconditionally.
	# Nowadays it's a standalone library: bug #802648
	DEPEND+=" sanitize? ( virtual/libcrypt )"
fi

if tc_has_feature systemtap ; then
	# gcc needs sys/sdt.h headers on target
	DEPEND+=" systemtap? ( dev-debug/systemtap )"
fi

if tc_has_feature zstd ; then
	DEPEND+=" zstd? ( app-arch/zstd:= )"
	RDEPEND+=" zstd? ( app-arch/zstd:= )"
fi

if tc_has_feature valgrind ; then
	BDEPEND+=" valgrind? ( dev-debug/valgrind )"
fi

# TODO: Add a pkg_setup & pkg_pretend check for whether the active compiler
# supports Ada.
if [[ ${PN} != gnat-gpl ]] && tc_has_feature ada ; then
	BDEPEND+=" ada? ( || ( sys-devel/gcc[ada] dev-lang/gnat-gpl[ada] ) )"
fi

# TODO: Add a pkg_setup & pkg_pretend check for whether the active compiler
# supports D.
if tc_has_feature d && tc_version_is_at_least 12.0 ; then
	# D in 12+ is self-hosting and needs D to bootstrap.
	# TODO: package some binary we can use, like for Ada
	# bug #840182
	BDEPEND+=" d? ( || ( sys-devel/gcc[d(-)] <sys-devel/gcc-12[d(-)] ) )"
fi

if tc_has_feature rust && tc_version_is_at_least 14.0.0_pre20230421 ; then
	# This was added upstream in r14-9968-g3e1e73fc995844 as a temporary measure.
	# See https://inbox.sourceware.org/gcc/34fec7ea-8762-4cac-a1c8-ff54e20e31ed@embecosm.com/
	BDEPEND+=" rust? ( virtual/rust )"
fi

PDEPEND=">=sys-devel/gcc-config-2.11"

#---->> S + SRC_URI essentials <<----

# @ECLASS_VARIABLE: TOOLCHAIN_PATCH_SUFFIX
# @DESCRIPTION:
# Used to override compression used for for patchsets.
# Default is xz for EAPI 8+ and bz2 for older EAPIs.
if [[ ${EAPI} == 8 ]] ; then
	: "${TOOLCHAIN_PATCH_SUFFIX:=xz}"
else
	# Older EAPIs
	: "${TOOLCHAIN_PATCH_SUFFIX:=bz2}"
fi

# @ECLASS_VARIABLE: TOOLCHAIN_SET_S
# @DESCRIPTION:
# Used to override value of S for snapshots and such. Mainly useful
# if needing to set GCC_TARBALL_SRC_URI.
: "${TOOLCHAIN_SET_S:=yes}"

# Set the source directory depending on whether we're using
# a live git tree, snapshot, or release tarball.
if [[ ${TOOLCHAIN_SET_S} == yes ]] ; then
	if tc_is_live ; then
		S=${EGIT_CHECKOUT_DIR}
	elif [[ -n ${SNAPSHOT} ]] ; then
		S=${WORKDIR}/gcc-${SNAPSHOT}
	else
		S=${WORKDIR}/gcc-${GCC_RELEASE_VER}
	fi
fi

gentoo_urls() {
	# the list is sorted by likelihood of getting the patches tarball from
	# respective devspace
	# slyfox's distfiles are mirrored to sam's devspace
	declare -A devspace_urls=(
		[soap]=HTTP~soap/distfiles/URI
		[sam]=HTTP~sam/distfiles/sys-devel/gcc/URI
		[slyfox]=HTTP~sam/distfiles/URI
		[xen0n]=HTTP~xen0n/distfiles/sys-devel/gcc/URI
		[tamiko]=HTTP~tamiko/distfiles/URI
		[zorry]=HTTP~zorry/patches/gcc/URI
		[vapier]=HTTP~vapier/dist/URI
		[blueness]=HTTP~blueness/dist/URI
	)

	# Newer ebuilds should set TOOLCHAIN_PATCH_DEV and we'll just
	# return the full URL from the array.
	if [[ -n ${TOOLCHAIN_PATCH_DEV} ]] ; then
		local devspace_url=${devspace_urls[${TOOLCHAIN_PATCH_DEV}]}
		if [[ -n ${devspace_url} ]] ; then
			local devspace_url_exp=${devspace_url//HTTP/https:\/\/dev.gentoo.org\/}
			devspace_url_exp=${devspace_url_exp//URI/$1}
			echo ${devspace_url_exp}
			return
		fi
	fi

	# But we keep the old fallback list for compatibility with
	# older ebuilds (overlays etc).
	local devspace="
		HTTP~soap/distfiles/URI
		HTTP~sam/distfiles/URI
		HTTP~sam/distfiles/sys-devel/gcc/URI
		HTTP~tamiko/distfiles/URI
		HTTP~zorry/patches/gcc/URI
		HTTP~vapier/dist/URI
		HTTP~blueness/dist/URI
	"
	devspace=${devspace//HTTP/https:\/\/dev.gentoo.org\/}
	echo ${devspace//URI/$1} mirror://gentoo/$1
}

# This function handles the basics of setting the SRC_URI for a gcc ebuild.
# To use, set SRC_URI with:
#
#	SRC_URI="$(get_gcc_src_uri)"
#
# Other than the variables normally set by portage, this function's behavior
# can be altered by setting the following:
#
#	GCC_TARBALL_SRC_URI
#			Override link to main tarball into SRC_URI. Used by dev-lang/gnat-gpl
#			to provide gcc tarball snapshots. Patches are usually reused as-is.
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
#			gcc-${PATCH_GCC_VER:-${GCC_RELEASE_VER}}-patches-${PATCH_VER}.tar.xz
#
get_gcc_src_uri() {
	export PATCH_GCC_VER=${PATCH_GCC_VER:-${GCC_RELEASE_VER}}
	export MUSL_GCC_VER=${MUSL_GCC_VER:-${PATCH_GCC_VER}}

	# Set where to download gcc itself depending on whether we're using a
	# live git tree, snapshot, or release tarball.
	if tc_is_live ; then
		: # Nothing to do w/git snapshots.
	elif [[ -n ${GCC_TARBALL_SRC_URI} ]] ; then
		# Pull gcc tarball from another location. Frequently used by gnat-gpl.
		GCC_SRC_URI="${GCC_TARBALL_SRC_URI}"
	elif [[ -n ${SNAPSHOT} ]] ; then
		GCC_SRC_URI="mirror://gcc/snapshots/${SNAPSHOT}/gcc-${SNAPSHOT}.tar.xz"
	else
		GCC_SRC_URI="
			mirror://gcc/releases/gcc-${GCC_PV}/gcc-${GCC_RELEASE_VER}.tar.xz
			mirror://gnu/gcc/gcc-${GCC_PV}/gcc-${GCC_RELEASE_VER}.tar.xz
		"
	fi

	[[ -n ${PATCH_VER} ]] && \
		GCC_SRC_URI+=" $(gentoo_urls gcc-${PATCH_GCC_VER}-patches-${PATCH_VER}.tar.${TOOLCHAIN_PATCH_SUFFIX})"
	[[ -n ${MUSL_VER} ]] && \
		GCC_SRC_URI+=" $(gentoo_urls gcc-${MUSL_GCC_VER}-musl-patches-${MUSL_VER}.tar.${TOOLCHAIN_PATCH_SUFFIX})"

	GCC_SRC_URI+=" test? ( https://gitweb.gentoo.org/proj/gcc-patches.git/plain/scripts/testsuite-management/validate_failures.py?id=${GCC_VALIDATE_FAILURES_VERSION} -> gcc-validate-failures-${GCC_VALIDATE_FAILURES_VERSION}.py )"

	echo "${GCC_SRC_URI}"
}

SRC_URI=$(get_gcc_src_uri)

#---->> pkg_pretend <<----

toolchain_pkg_pretend() {
	if ! _tc_use_if_iuse cxx ; then
		_tc_use_if_iuse go && \
			ewarn 'Go requires a C++ compiler, disabled due to USE="-cxx"'
		_tc_use_if_iuse objc++ && \
			ewarn 'Obj-C++ requires a C++ compiler, disabled due to USE="-cxx"'
	fi
}

#---->> pkg_setup <<----

toolchain_pkg_setup() {
	# We don't want to use the installed compiler's specs to build gcc
	unset GCC_SPECS

	# bug #265283
	unset LANGUAGES

	# See https://www.gnu.org/software/make/manual/html_node/Parallel-Output.html
	# Avoid really confusing logs from subconfigure spam, makes logs far
	# more legible.
	MAKEOPTS="--output-sync=line ${MAKEOPTS}"

	use test && python-any-r1_pkg_setup
}

#---->> src_unpack <<----

# @FUNCTION: toolchain_fetch_git_patches
# @INTERNAL
# @DESCRIPTION:
# Fetch patches from Gentoo's gcc-patches repository.
toolchain_fetch_git_patches() {
	local gcc_patches_repo="https://anongit.gentoo.org/git/proj/gcc-patches.git https://github.com/gentoo/gcc-patches"

	# If we weren't given a patchset number, pull it from git too.
	einfo "Fetching patchset from git as PATCH_VER is unset"
	EGIT_REPO_URI=${gcc_patches_repo} EGIT_BRANCH="master" \
		EGIT_CHECKOUT_DIR="${WORKDIR}"/patch.tmp \
		git-r3_src_unpack

	mkdir "${WORKDIR}"/patch || die
	mv "${WORKDIR}"/patch.tmp/${PATCH_GCC_VER}/gentoo/* "${WORKDIR}"/patch || die

	if [[ -z ${MUSL_VER} || -d "${WORKDIR}"/musl ]] && [[ ${CTARGET} == *musl* ]] ; then
		mkdir "${WORKDIR}"/musl || die
		mv "${WORKDIR}"/patch.tmp/${PATCH_GCC_VER}/musl/* "${WORKDIR}"/musl || die
	fi
}

toolchain_src_unpack() {
	if tc_is_live ; then
		git-r3_src_unpack

		# Needed for gcc --version to include the upstream commit used
		# rather than only the commit after we apply our patches.
		# It includes both with this.
		echo "${EGIT_VERSION}" > "${S}"/gcc/REVISION || die

		if [[ -z ${PATCH_VER} ]] && ! use vanilla ; then
			toolchain_fetch_git_patches
		fi
	elif [[ -z ${PATCH_VER} && -n ${TOOLCHAIN_USE_GIT_PATCHES} ]] ; then
		toolchain_fetch_git_patches
	fi

	default
}

#---->> src_prepare <<----

toolchain_src_prepare() {
	export BRANDING_GCC_PKGVERSION="Gentoo ${GCC_PVR}"
	cd "${S}" || die

	do_gcc_gentoo_patches

	if tc_is_live ; then
		BRANDING_GCC_PKGVERSION="${BRANDING_GCC_PKGVERSION}, commit ${EGIT_VERSION}"
	fi

	eapply_user

	if ! use vanilla ; then
		tc_enable_hardened_gcc
	fi

	if use test ; then
		cp "${DISTDIR}"/gcc-validate-failures-${GCC_VALIDATE_FAILURES_VERSION}.py "${T}"/validate_failures.py || die
		chmod +x "${T}"/validate_failures.py || die
	fi

	# Make sure the pkg-config files install into multilib dirs.
	# Since we configure with just one --libdir, we can't use that
	# (as gcc itself takes care of building multilibs). bug #435728
	find "${S}" -name Makefile.in \
		-exec sed -i '/^pkgconfigdir/s:=.*:=$(toolexeclibdir)/pkgconfig:' {} + || die

	setup_multilib_osdirnames

	local actual_version=$(< "${S}"/gcc/BASE-VER)
	if ! tc_is_live && [[ "${GCC_RELEASE_VER}" != "${actual_version}" ]] ; then
		eerror "'${S}/gcc/BASE-VER' contains '${actual_version}', expected '${GCC_RELEASE_VER}'"
		die "Please set 'TOOLCHAIN_GCC_PV' to '${actual_version}'"
	fi

	# Fixup libtool to correctly generate .la files with portage
	elibtoolize --portage --shallow --no-uclibc

	gnuconfig_update

	if ! use prefix-guest && [[ -n ${EPREFIX} ]] ; then
		einfo "Prefixifying dynamic linkers..."
		for f in gcc/config/*/*linux*.h ; do
			ebegin "  Updating ${f}"
			if [[ ${f} == gcc/config/rs6000/linux*.h ]]; then
				sed -i -r "s,(DYNAMIC_LINKER_PREFIX\s+)\"\",\1\"${EPREFIX}\",g" "${f}" || die
			else
				sed -i -r "/_DYNAMIC_LINKER/s,([\":])(/lib),\1${EPREFIX}\2,g" "${f}" || die
			fi
			eend $?
		done
	fi

	einfo "Touching generated files"
	./contrib/gcc_update --touch | \
		while read f ; do
			einfo "  ${f%%...}"
		done
}

do_gcc_gentoo_patches() {
	if ! use vanilla ; then
		if [[ -n ${PATCH_VER} || -d "${WORKDIR}"/patch ]] ; then
			einfo "Applying Gentoo patches ..."
			eapply "${WORKDIR}"/patch/*.patch
			BRANDING_GCC_PKGVERSION="${BRANDING_GCC_PKGVERSION} p${PATCH_VER}"
		fi

		if [[ -n ${MUSL_VER} || -d "${WORKDIR}"/musl ]] && [[ ${CTARGET} == *musl* ]] ; then
			if [[ ${CATEGORY} == cross-* ]] ; then
				# We don't want to apply some patches when cross-compiling.
				if [[ -d "${WORKDIR}"/musl/nocross ]] ; then
					rm -fv "${WORKDIR}"/musl/nocross/*.patch || die
				else
					# Just make an empty directory to make the glob below easier.
					mkdir -p "${WORKDIR}"/musl/nocross || die
				fi
			fi

			local shopt_save=$(shopt -p nullglob)
			shopt -s nullglob
			einfo "Applying musl patches ..."
			eapply "${WORKDIR}"/musl/{,nocross/}*.patch
			${shopt_save}
		fi
	fi
}

# configure to build with the hardened GCC specs as the default
tc_enable_hardened_gcc() {
	local hardened_gcc_flags=""

	if _tc_use_if_iuse pie ; then
		einfo "Updating gcc to use automatic PIE building ..."
	fi

	if _tc_use_if_iuse ssp ; then
		einfo "Updating gcc to use automatic SSP building ..."
	fi

	if _tc_use_if_iuse default-stack-clash-protection ; then
		# The define DEF_GENTOO_SCP is checked in 24_all_DEF_GENTOO_SCP-fstack-clash-protection.patch
		einfo "Updating gcc to use automatic stack clash protection ..."
		hardened_gcc_flags+=" -DDEF_GENTOO_SCP"
	fi

	if _tc_use_if_iuse default-znow ; then
		# The define DEF_GENTOO_ZNOW is checked in 23_all_DEF_GENTOO_ZNOW-z-now.patch
		einfo "Updating gcc to request symbol resolution at start (-z now) ..."
		hardened_gcc_flags+=" -DDEF_GENTOO_ZNOW"
	fi

	if _tc_use_if_iuse cet && [[ ${CTARGET} == *x86_64*-linux-gnu* ]] ; then
		einfo "Updating gcc to use x86-64 control flow protection by default ..."
		hardened_gcc_flags+=" -DEXTRA_OPTIONS_CF"
	fi

	if _tc_use_if_iuse hardened ; then
		# Will add some hardened options as default, e.g. for gcc-12
		# * -fstack-clash-protection
		# * -z now
		# See gcc *_all_extra-options.patch patches.
		hardened_gcc_flags+=" -DEXTRA_OPTIONS"
		# Default to -D_FORTIFY_SOURCE=3 instead of -D_FORTIFY_SOURCE=2
		hardened_gcc_flags+=" -DGENTOO_FORTIFY_SOURCE_LEVEL=3"
		# Add -D_GLIBCXX_ASSERTIONS
		hardened_gcc_flags+=" -DDEF_GENTOO_GLIBCXX_ASSERTIONS"

		# Rebrand to make bug reports easier
		BRANDING_GCC_PKGVERSION=${BRANDING_GCC_PKGVERSION/Gentoo/Gentoo Hardened}
	fi

	# We want to be able to control the PIE patch logic via something other
	# than ALL_CFLAGS...
	sed -e '/^ALL_CFLAGS/iHARD_CFLAGS = ' \
		-e 's|^ALL_CFLAGS = |ALL_CFLAGS = $(HARD_CFLAGS) |' \
		-i "${S}"/gcc/Makefile.in || die

	sed -e '/^ALL_CXXFLAGS/iHARD_CFLAGS = ' \
		-e 's|^ALL_CXXFLAGS = |ALL_CXXFLAGS = $(HARD_CFLAGS) |' \
		-i "${S}"/gcc/Makefile.in || die

	sed -i \
		-e "/^HARD_CFLAGS = /s|=|= ${hardened_gcc_flags} |" \
		"${S}"/gcc/Makefile.in || die

}

# This is a historical wart.  The original Gentoo/amd64 port used:
#    lib32 - 32bit binaries (x86)
#    lib64 - 64bit binaries (x86_64)
#    lib   - "native" binaries (a symlink to lib64)
# Most other distros use the logic (including mainline gcc):
#    lib   - 32bit binaries (x86)
#    lib64 - 64bit binaries (x86_64)
# Over time, Gentoo is migrating to the latter form (17.1 profiles).
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

	# This only makes sense for some Linux targets
	case ${CTARGET} in
		x86_64*-linux*)    config="i386" ;;
		powerpc64*-linux*) config="rs6000" ;;
		sparc64*-linux*)   config="sparc" ;;
		s390x*-linux*)     config="s390" ;;
		*)	               return 0 ;;
	esac
	config+="/t-linux64"

	local sed_args=()
	sed_args+=( -e 's:$[(]call if_multiarch[^)]*[)]::g' )
	if [[ ${SYMLINK_LIB} == "yes" ]] ; then
		einfo "Updating multilib directories to be: ${libdirs}"
		sed_args+=( -e '/^MULTILIB_OSDIRNAMES.*lib32/s:[$][(]if.*):../lib32:' )
	else
		einfo "Using upstream multilib; disabling lib32 autodetection"
		sed_args+=( -r -e 's:[$][(]if.*,(.*)[)]:\1:' )
	fi
	sed -i "${sed_args[@]}" "${S}"/gcc/config/${config} || die
}

#---->> src_configure <<----

toolchain_src_configure() {
	BUILD_CONFIG_TARGETS=()
	is-flagq '-O3' && BUILD_CONFIG_TARGETS+=( bootstrap-O3 )

	downgrade_arch_flags
	gcc_do_filter_flags

	if ! tc_version_is_at_least 11 && [[ $(gcc-major-version) -ge 12 ]] ; then
		# https://gcc.gnu.org/PR105695
		# bug #849359
		export ac_cv_std_swap_in_utility=no
	fi

	einfo "CFLAGS=\"${CFLAGS}\""
	einfo "CXXFLAGS=\"${CXXFLAGS}\""
	einfo "LDFLAGS=\"${LDFLAGS}\""

	# Force internal zip based jar script to avoid random
	# issues with 3rd party jar implementations. bug #384291
	export JAR=no

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

		# portage's econf() does not detect presence of --d-s-r
		# because it greps only top-level ./configure. But not
		# libiberty's or gcc's configure.
		--disable-silent-rules
	)

	if tc_version_is_at_least 10 ; then
		confgcc+=(
			--disable-dependency-tracking
		)
	fi

	# Stick the python scripts in their own slotted directory (bug #279252)
	#
	#  --with-python-dir=DIR
	#  Specifies where to install the Python modules used for aot-compile. DIR
	#  should not include the prefix used in installation. For example, if the
	#  Python modules are to be installed in /usr/lib/python2.5/site-packages,
	#  then --with-python-dir=/lib/python2.5/site-packages should be passed.
	#
	# This should translate into "/share/gcc-data/${CTARGET}/${GCC_CONFIG_VER}/python"
	confgcc+=( --with-python-dir=${DATAPATH/$PREFIX/}/python )

	### language options

	local GCC_LANG="c"
	is_cxx && GCC_LANG+=",c++"
	is_d   && GCC_LANG+=",d"
	is_go  && GCC_LANG+=",go"
	if is_objc || is_objcxx ; then
		GCC_LANG+=",objc"
		use objc-gc && confgcc+=( --enable-objc-gc )
		is_objcxx && GCC_LANG+=",obj-c++"
	fi

	# Fortran support just got sillier! The lang value can be f77 for
	# fortran77, f95 for fortran95, or just plain old fortran for the
	# currently supported standard depending on gcc version.
	is_fortran && GCC_LANG+=",fortran"
	is_f77 && GCC_LANG+=",f77"
	is_f95 && GCC_LANG+=",f95"
	is_ada && GCC_LANG+=",ada"
	is_modula2 && GCC_LANG+=",m2"
	is_rust && GCC_LANG+=",rust"

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

	confgcc+=( --disable-libunwind-exceptions )

	if in_iuse debug ; then
		# Non-released versions get extra checks, follow configure.ac's default to for those
		# unless USE=debug. Note that snapshots on stable branches don't count as "non-released"
		# for these purposes.
		if grep -q "experimental" gcc/DEV-PHASE ; then
			# - USE=debug for pre-releases: yes,extra,rtl
			# - USE=-debug for pre-releases: yes,extra (following upstream default)
			confgcc+=( --enable-checking="${GCC_CHECKS_LIST:-$(usex debug yes,extra,rtl yes,extra)}" )
		else
			# - Use the default ("release") checking because upstream usually neglects
			#   to test "disabled" so it has a history of breaking. bug #317217.
			# - The "release" keyword is new to 4.0. bug #551636.
			# - After discussing in #gcc, we concluded that =yes,extra,rtl makes
			#   more sense when a user explicitly requests USE=debug. If rtl is too slow,
			#   we can change this to yes,extra.
			confgcc+=( --enable-checking="${GCC_CHECKS_LIST:-$(usex debug yes,extra,rtl release)}" )
		fi
	fi

	# Branding
	confgcc+=(
		--with-bugurl=https://bugs.gentoo.org/
		--with-pkgversion="${BRANDING_GCC_PKGVERSION}"
	)

	if tc_use_major_version_only ; then
		confgcc+=( --with-gcc-major-version-only )
	fi

	# Allow gcc to search for clock funcs in the main C lib.
	# if it can't find them, then tough cookies -- we aren't
	# going to link in -lrt to all C++ apps. bug #411681
	if is_cxx ; then
		confgcc+=( --enable-libstdcxx-time )
	fi

	# This only controls whether the compiler *supports* LTO, not whether
	# it's *built using* LTO. Hence we do it without a USE flag.
	confgcc+=( --enable-lto )

	# Build compiler itself using LTO
	if tc_version_is_at_least 9.1 && _tc_use_if_iuse lto ; then
		BUILD_CONFIG_TARGETS+=( bootstrap-lto )
	fi

	if tc_version_is_at_least 12 && _tc_use_if_iuse cet && [[ ${CTARGET} == x86_64-*-gnu* ]] ; then
		BUILD_CONFIG_TARGETS+=( bootstrap-cet )
	fi

	# Support to disable PCH when building libstdcxx
	if ! _tc_use_if_iuse pch ; then
		confgcc+=( --disable-libstdcxx-pch )
	fi

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

	### Cross-compiler options
	if is_crosscompile ; then
		# Enable build warnings by default with cross-compilers when system
		# paths are included (e.g. via -I flags).
		confgcc+=( --enable-poison-system-directories )

		# When building a stage1 cross-compiler (just C compiler), we have to
		# disable a bunch of features or gcc goes boom
		local needed_libc=""
		case ${CTARGET} in
			*-linux)
				needed_libc=error-unknown-libc
				;;
			*-dietlibc)
				needed_libc=dietlibc
				;;
			*-elf|*-eabi)
				needed_libc=newlib
				# Bare-metal targets don't have access to clock_gettime()
				# arm-none-eabi example: bug #589672
				# But we explicitly do --enable-libstdcxx-time above.
				# Undoing it here.
				confgcc+=( --disable-libstdcxx-time )
				;;
			*-gnu*)
				needed_libc=glibc
				;;
			*-klibc)
				needed_libc=klibc
				;;
			*-musl*)
				needed_libc=musl
				;;
			x86_64-*-mingw*|*-w64-mingw*)
				needed_libc=mingw64-runtime
				;;
			avr)
				confgcc+=( --enable-shared --disable-threads )
				;;
			nvptx*)
				# "LTO is not supported for this target"
				confgcc+=( --disable-lto )
				;;
		esac

		if [[ -n ${needed_libc} ]] ; then
			local confgcc_no_libc=( --disable-shared )
			# requires libc: bug #734820
			confgcc_no_libc+=( --disable-libquadmath )
			# requires libc
			confgcc_no_libc+=( --disable-libatomic )

			if ! has_version ${CATEGORY}/${needed_libc} ; then
				confgcc+=(
					"${confgcc_no_libc[@]}"
					--disable-threads
					--without-headers
				)

				if [[ ${needed_libc} == glibc ]] ; then
					# By default gcc looks at glibc's headers
					# to detect long double support. This does
					# not work for --disable-headers mode.
					# Any >=glibc-2.4 is good enough for float128.
					# The option appeared in gcc-4.2.
					confgcc+=( --with-long-double-128 )
				fi
			elif has_version "${CATEGORY}/${needed_libc}[headers-only(-)]" ; then
				confgcc+=(
					"${confgcc_no_libc[@]}"
					--with-sysroot="${PREFIX}"/${CTARGET}
				)
			else
				confgcc+=( --with-sysroot="${PREFIX}"/${CTARGET} )
			fi
		fi

		confgcc+=(
			# https://gcc.gnu.org/PR100289
			# TOOD: Find a way to disable this just for stage1 cross?
			--disable-gcov

			--disable-bootstrap
		)
	else
		if tc-is-static-only ; then
			confgcc+=( --disable-shared )
		else
			confgcc+=( --enable-shared )
		fi
		case ${CHOST} in
			mingw*|*-mingw*)
				confgcc+=( --enable-threads=win32 )
				;;
			*)
				confgcc+=( --enable-threads=posix )
				;;
		esac

		if ! use prefix-guest ; then
			# GNU ld scripts, such as those in glibc, reference unprefixed paths
			# as the sysroot given here is automatically prepended. For
			# prefix-guest, we use the host's libc instead.
			if [[ -n ${EPREFIX} ]] ; then
				confgcc+=( --with-sysroot="${EPREFIX}" )
			fi

			# We need to build against the right headers and libraries. Again,
			# for prefix-guest, this is the host's.
			if [[ -n ${ESYSROOT} ]] ; then
				confgcc+=( --with-build-sysroot="${ESYSROOT}" )
			fi
		fi
	fi

	# __cxa_atexit is "essential for fully standards-compliant handling of
	# destructors", but apparently requires glibc.
	case ${CTARGET} in
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
		*-solaris*)
			confgcc+=( --enable-__cxa_atexit )
			;;
	esac

	### arch options

	gcc-multilib-configure

	# gcc has fixed-point arithmetic support in 4.3 for mips targets that can
	# significantly increase compile time by several hours.  This will allow
	# users to control this feature in the event they need the support.
	in_iuse fixed-point && confgcc+=( $(use_enable fixed-point) )

	case $(tc-is-softfloat) in
		yes)
			confgcc+=( --with-float=soft )
			;;
		softfp)
			confgcc+=( --with-float=softfp )
			;;
		*)
			# If they've explicitly opt-ed in, do hardfloat,
			# otherwise let the gcc default kick in.
			case ${CTARGET//_/-} in
				*-hardfloat-*|*eabihf)
					confgcc+=( --with-float=hard )
				;;
			esac
	esac

	local with_abi_map=()
	case $(tc-arch) in
		arm)
			# bug #264534, bug #414395
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

			# Make default mode thumb for microcontroller classes, bug #418209
			[[ ${arm_arch} == *-m ]] && confgcc+=( --with-mode=thumb )

			# Enable hardvfp
			if [[ $(tc-is-softfloat) == "no" ]] && [[ ${CTARGET} == armv[67]* ]] ; then
				# Follow the new arm hardfp distro standard by default
				confgcc+=( --with-float=hard )
				case ${CTARGET} in
					armv6*) confgcc+=( --with-fpu=vfp ) ;;
					armv7*) confgcc+=( --with-fpu=vfpv3-d16 ) ;;
				esac
			fi

			# If multilib is used, make the compiler build multilibs
			# for A or R and M architecture profiles. Do this only
			# when no specific arch/mode/float is specified, e.g.
			# for target arm-none-eabi, since doing this is
			# incompatible with --with-arch/cpu/float/fpu.
			if is_multilib && [[ ${arm_arch} == arm ]] ; then
				confgcc+=( --with-multilib-list=aprofile,rmprofile )
			fi
			;;
		mips)
			# Add --with-abi flags to set default ABI
			confgcc+=( --with-abi=$(gcc-abi-map ${TARGET_DEFAULT_ABI}) )
			;;

		amd64)
			# drop the older/ABI checks once this gets merged into some
			# version of gcc upstream
			if has x32 $(get_all_abis TARGET) ; then
				confgcc+=( --with-abi=$(gcc-abi-map ${TARGET_DEFAULT_ABI}) )
			fi
			;;
		x86)
			# Default arch for x86 is normally i386, let's give it a bump
			# since glibc will do so based on CTARGET anyways
			confgcc+=( --with-arch=${CTARGET%%-*} )
			;;
		ppc)
			# Set up defaults based on current CFLAGS
			is-flagq -mfloat-gprs=double && confgcc+=( --enable-e500-double )
			[[ ${CTARGET//_/-} == *-e500v2-* ]] && confgcc+=( --enable-e500-double )
			;;
		ppc64)
			# On ppc64, the big endian target gcc assumes elfv1 by default,
			# and elfv2 on little endian.
			# But musl does not support elfv1 at all on any endian ppc64.
			# See:
			# - https://git.musl-libc.org/cgit/musl/tree/INSTALL
			# - bug #704784
			# - https://gcc.gnu.org/PR93157
			# musl additionally does not support libquadmath.  See:
			# - https://gcc.gnu.org/PR116007
			[[ ${CTARGET} == powerpc64-*-musl ]] && confgcc+=(
				--with-abi=elfv2
				--disable-libquadmath
				--disable-libquadmath-support
				--with-long-double-128=no
			)

			if in_iuse ieee-long-double; then
				# musl requires 64-bit long double, not IBM double-double or IEEE quad.
				if [[ ${CTARGET} == powerpc64le-*-gnu ]]; then
					use ieee-long-double && confgcc+=( --with-long-double-format=ieee )
				fi
			fi
			;;
		riscv)
			# Add --with-abi flags to set default ABI
			confgcc+=( --with-abi=$(gcc-abi-map ${TARGET_DEFAULT_ABI}) )
			;;
	esac

	# If the target can do biarch (-m32/-m64), enable it.  overhead should
	# be small, and should simplify building of 64bit kernels in a 32bit
	# userland by not needing sys-devel/kgcc64. bug #349405
	case $(tc-arch) in
		amd64|ppc|ppc64|sparc|x86)
			confgcc+=( --enable-targets=all )
			;;
		*)
			;;
	esac

	# On Darwin we need libdir to be set in order to get correct install names
	# for things like libobjc-gnu and libfortran.  If we enable it on
	# non-Darwin we screw up the behaviour this eclass relies on.  We in
	# particular need this over --libdir for bug #255315.
	[[ ${CTARGET} == *-darwin* ]] && \
		confgcc+=( --enable-version-specific-runtime-libs )

	### library options

	if in_iuse openmp ; then
		# Make sure target has pthreads support: bug #326757, bug #335883
		# There shouldn't be a chicken & egg problem here as openmp won't
		# build without a C library, and you can't build that w/o
		# already having a compiler...
		if ! is_crosscompile || \
		   $(tc-getCPP ${CTARGET}) -E - <<<"#include <pthread.h>" >& /dev/null
		then
			confgcc+=( $(use_enable openmp libgomp) )
		else
			# Force disable as the configure script can be dumb, bug #359855
			confgcc+=( --disable-libgomp )
		fi
	else
		# For gcc variants where we don't want openmp (e.g. kgcc)
		confgcc+=( --disable-libgomp )
	fi

	if _tc_use_if_iuse libssp ; then
		confgcc+=( --enable-libssp )
	else
		if _tc_use_if_iuse ssp; then
			# On some targets USE="ssp -libssp" is an invalid
			# configuration as the target libc does not provide
			# stack_chk_* functions. Do not disable libssp there.
			case ${CTARGET} in
				mingw*|*-mingw*)
					ewarn "Not disabling libssp"
					;;
				*)
					confgcc+=( --disable-libssp )
					;;
			esac
		else
			confgcc+=( --disable-libssp )
		fi
	fi

	if in_iuse ada ; then
		confgcc+=( --disable-libada )
	fi

	if in_iuse cet ; then
		[[ ${CTARGET} == x86_64-*-gnu* ]] && confgcc+=( $(use_enable cet) )
		[[ ${CTARGET} == aarch64-*-gnu* ]] && confgcc+=( $(use_enable cet standard-branch-protection) )
	fi

	if in_iuse systemtap ; then
		confgcc+=( $(use_enable systemtap) )
	fi

	if in_iuse valgrind ; then
		confgcc+=( $(use_enable valgrind valgrind-annotations) )
	fi

	if in_iuse vtv ; then
		confgcc+=(
			$(use_enable vtv vtable-verify)
			# See Note [implicitly enabled flags]
			$(usex vtv '' --disable-libvtv)
		)
	fi

	if in_iuse zstd ; then
		confgcc+=( $(use_with zstd) )
	fi

	# graphite was added in 4.4 but we only support it in 6.5+ due to external
	# library issues. bug #448024, bug #701270
	if in_iuse graphite ; then
		confgcc+=( $(use_with graphite isl) )
		use graphite && confgcc+=( --disable-isl-version-check )
	else
		confgcc+=( --without-isl )
	fi

	if in_iuse sanitize ; then
		# See Note [implicitly enabled flags]
		confgcc+=( $(usex sanitize '' --disable-libsanitizer) )
	else
		confgcc+=( --disable-libsanitizer )
	fi

	if in_iuse pie ; then
		confgcc+=( $(use_enable pie default-pie) )

		if tc_version_is_at_least 14.0.0_pre20230612 ${PV} ; then
			confgcc+=( --enable-host-pie )
		fi
	fi

	if in_iuse default-znow && tc_version_is_at_least 14.0.0_pre20230619 ${PV}; then
		# See https://gcc.gnu.org/git/?p=gcc.git;a=commit;h=33ebb0dff9bb022f1e0709e0e73faabfc3df7931.
		# TODO: Add to LDFLAGS_FOR_TARGET?
		confgcc+=(
			$(use_enable default-znow host-bind-now)
		)
	fi

	if in_iuse ssp ; then
		confgcc+=(
			# This defaults to -fstack-protector-strong.
			$(use_enable ssp default-ssp)
		)
	fi

	if tc_version_is_at_least 13.1 ; then
		# Re-enable fixincludes for >= GCC 13 with older glibc
		# https://gcc.gnu.org/PR107128
		if ! is_crosscompile && use elibc_glibc && has_version "<sys-libs/glibc-2.38" ; then
			GCC_RUN_FIXINCLUDES=1
		fi

		case ${CBUILD}-${CHOST}-${CTARGET} in
			*i686-w64-mingw32*|*x86_64-w64-mingw32*)
				# config/i386/t-cygming requires fixincludes (bug #925204)
				GCC_RUN_FIXINCLUDES=1
				;;
			*mips*-sde-elf*)
				# config/mips/t-sdemtk needs fixincludes too (bug #925204)
				# It maps to mips*-sde-elf*, but only with --without-newlib.
				if [[ ${confgcc} != *with-newlib* ]] ; then
					GCC_RUN_FIXINCLUDES=1
				fi
				;;
			*)
				;;
		esac

		if [[ ${GCC_RUN_FIXINCLUDES} == 1 ]] ; then
			confgcc+=( --enable-fixincludes )
		else
			confgcc+=( --disable-fixincludes )
		fi
	fi

	# TODO: Ignore RCs here (but TOOLCHAIN_IS_RC isn't yet an eclass var)
	if [[ ${PV} == *_p* && -f "${S}"/gcc/doc/gcc.info ]] ; then
		# Safeguard against https://gcc.gnu.org/PR106899 being fixed
		# without corresponding ebuild changes.
		eqawarn "Snapshot release with pre-generated info pages found!"
		eqawarn "The BDEPEND in the ebuild should be updated to drop texinfo."
	fi

	# Do not let the X detection get in our way.  We know things can be found
	# via system paths, so no need to hardcode things that'll break multilib.
	# Older gcc versions will detect ac_x_libraries=/usr/lib64 which ends up
	# killing the 32bit builds which want /usr/lib.
	export ac_cv_have_x='have_x=yes ac_x_includes= ac_x_libraries='

	eval "local -a EXTRA_ECONF=(${EXTRA_ECONF})"
	confgcc+=( "$@" "${EXTRA_ECONF[@]}" )

	if ! is_crosscompile && ! tc-is-cross-compiler && [[ -n ${BUILD_CONFIG_TARGETS} ]] ; then
		# e.g. ./configure --with-build-config='bootstrap-lto bootstrap-cet'
		confgcc+=( --with-build-config="${BUILD_CONFIG_TARGETS[*]}" )
	fi

	# Nothing wrong with a good dose of verbosity
	echo
	einfo "PREFIX:          ${PREFIX}"
	einfo "BINPATH:         ${BINPATH}"
	einfo "LIBPATH:         ${LIBPATH}"
	einfo "DATAPATH:        ${DATAPATH}"
	einfo "STDCXX_INCDIR:   ${STDCXX_INCDIR}"
	einfo "Languages:       ${GCC_LANG}"
	echo

	# Build in a separate build tree
	mkdir -p "${WORKDIR}"/build || die
	pushd "${WORKDIR}"/build > /dev/null || die

	# ...and now to do the actual configuration
	addwrite /dev/zero

	local gcc_shell="${BROOT}"/bin/bash
	# Older gcc versions did not detect bash and re-exec itself, so force the
	# use of bash for them.
	if tc_version_is_at_least 11.2 ; then
		gcc_shell="${BROOT}"/bin/sh
	fi

	if is_jit ; then
		einfo "Configuring JIT gcc"

		local confgcc_jit=(
			"${confgcc[@]}"

			--enable-lto
			--disable-analyzer
			--disable-bootstrap
			--disable-cet
			--disable-default-pie
			--disable-default-ssp
			--disable-gcov
			--disable-libada
			--disable-libatomic
			--disable-libgomp
			--disable-libitm
			--disable-libquadmath
			--disable-libsanitizer
			--disable-libssp
			--disable-libstdcxx-pch
			--disable-libvtv
			--disable-nls
			--disable-objc-gc
			--disable-systemtap
			--enable-host-shared
			--enable-languages=jit
			# Might be used for the just-built GCC. Easier to just
			# respect USE=graphite here in case the user passes some
			# graphite flags rather than try strip them out.
			$(use_with graphite isl)
			$(use_with zstd)
			--with-system-zlib
		)

		if tc_version_is_at_least 13.1 ; then
			confgcc_jit+=( --disable-fixincludes )
		fi

		mkdir -p "${WORKDIR}"/build-jit || die
		pushd "${WORKDIR}"/build-jit > /dev/null || die

		CONFIG_SHELL="${gcc_shell}" edo "${gcc_shell}" "${S}"/configure "${confgcc_jit[@]}"
		popd > /dev/null || die
	fi

	CONFIG_SHELL="${gcc_shell}" edo "${gcc_shell}" "${S}"/configure "${confgcc[@]}"

	# Return to whatever directory we were in before
	popd > /dev/null || die
}

# Replace -m flags unsupported by the version being built with the best
# available equivalent
downgrade_arch_flags() {
	local arch bver i isa myarch mytune rep ver

	bver=${1:-${GCC_BRANCH_VER}}
	# Don't perform downgrade if running gcc is older than ebuild's.
	tc_version_is_at_least ${bver} $(gcc-version) || return 0
	[[ $(tc-arch) != amd64 && $(tc-arch) != x86 ]] && return 0

	myarch=$(get-flag march)
	mytune=$(get-flag mtune)

	# Handle special -mtune flags
	[[ ${mytune} == intel ]] && ! tc_version_is_at_least 4.9 ${bver} && replace-cpu-flags intel generic
	[[ ${mytune} == x86-64 ]] && filter-flags '-mtune=*'

	# "added" "arch" "replacement"
	local archlist=(
		12.3 znver4 znver3
		10 znver3 znver2
		9 znver2 znver1
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
	)

	for ((i = 0; i < ${#archlist[@]}; i += 3)) ; do
		myarch=$(get-flag march)
		mytune=$(get-flag mtune)

		ver=${archlist[i]}
		arch=${archlist[i + 1]}
		rep=${archlist[i + 2]}

		[[ ${myarch} != ${arch} && ${mytune} != ${arch} ]] && continue

		if ! tc_version_is_at_least ${ver} ${bver}; then
			einfo "Downgrading '${myarch}' (added in gcc ${ver}) with '${rep}'..."
			[[ ${myarch} == ${arch} ]] && replace-cpu-flags ${myarch} ${rep}
			[[ ${mytune} == ${arch} ]] && replace-cpu-flags ${mytune} ${rep}
			continue
		else
			break
		fi
	done

	# We only check -mno* here since -m* get removed by strip-flags later on
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
		tc_version_is_at_least ${ver} ${bver} || filter-flags ${isa} ${isa/-m/-mno-}
	done
}

gcc_do_filter_flags() {
	# Allow users to explicitly avoid flag sanitization via
	# USE=custom-cflags.
	if ! _tc_use_if_iuse custom-cflags; then
		# Over-zealous CFLAGS can often cause problems.  What may work for one
		# person may not work for another.  To avoid a large influx of bugs
		# relating to failed builds, we strip most CFLAGS out to ensure as few
		# problems as possible.
		strip-flags

		# Lock gcc at -O2; we want to be conservative here.
		filter-flags '-O?'

		# We allow -O3 given it's a supported option upstream.
		# Only add -O2 if we're not doing -O3.
		if [[ ${BUILD_CONFIG_TARGETS[@]} == *bootstrap-O3* ]] ; then
			append-flags '-O3'
		else
			append-flags '-O2'
		fi
	fi

	declare -A l1_cache_sizes=()
	# Workaround for inconsistent cache sizes on hybrid P/E cores
	# See PR111768 (and bug #904426, bug #908523, and bug #915389)
	if [[ ${CBUILD} == @(x86_64|i?86)* ]] && [[ ${CFLAGS} == *-march=native* ]] && tc-is-gcc ; then
		local x
		local l1_cache_size
		# Iterate over all cores and find their L1 cache size
		for x in $(seq 0 $(($(nproc)-1))) ; do
			[[ -z ${x} || ${x} -gt 64 ]] && break
			l1_cache_size=$(taskset --cpu-list ${x} $(tc-getCC) -Q --help=params -O2 -march=native \
				| awk '{ if ($1 ~ /^.*param.*l1-cache-size/) print $2; }' || die)
			[[ -n ${l1_cache_size} && ${l1_cache_size} =~ ^[0-9]+$ ]] || break
			l1_cache_sizes[${l1_cache_size}]=1
		done
		# If any of them are different, abort. We can't just pass one value of
		# l1-cache-size because it doesn't cancel out the -march=native one.
		if [[ ${#l1_cache_sizes[@]} -gt 1 ]] ; then
			eerror "Different values of l1-cache-size detected!"
			eerror "GCC will fail to bootstrap when comparing files with these flags."
			eerror "This CPU is likely big.little/hybrid hardware with power/efficiency cores."
			eerror "Please install app-misc/resolve-march-native and run 'resolve-march-native'"
			eerror "to find a safe value of CFLAGS for this CPU. Note that this may vary"
			eerror "depending on the core it ran on. taskset can be used to fix the cores used."
			die "Varying l1-cache-size found, aborting (bug #915389, gcc PR#111768)"
		fi
	fi

	if ver_test -lt 13.6 ; then
		# These aren't supported by the just-built compiler either.
		filter-flags -fharden-compares -fharden-conditional-branches \
			-fharden-control-flow-redundancy -fno-harden-control-flow-redundancy \
			-fhardcfr-skip-leaf -fhardcfr-check-exceptions \
			-fhardcfr-check-returning-calls '-fhardcfr-check-noreturn-calls=*'

		# New in GCC 14.
		filter-flags -Walloc-size
	fi

	# Please use USE=lto instead (bug #906007).
	filter-lto

	# Avoid shooting self in foot
	filter-flags '-mabi*' -m31 -m32 -m64

	# bug #490738
	filter-flags -frecord-gcc-switches
	# bug #506202
	filter-flags -mno-rtm -mno-htm

	filter-flags '-fsanitize=*'

	case $(tc-arch) in
		amd64|x86)
			filter-flags '-mcpu=*'
			;;
		alpha)
			# bug #454426
			append-ldflags -Wl,--no-relax
			;;
	esac

	strip-unsupported-flags

	# These are set here so we have something sane at configure time
	if is_crosscompile ; then
		# Set this to something sane for both native and target
		CFLAGS="-O2 -pipe"
		FFLAGS=${CFLAGS}
		FCFLAGS=${CFLAGS}

		# "hppa2.0-unknown-linux-gnu" -> hppa2_0_unknown_linux_gnu
		local VAR="CFLAGS_"${CTARGET//[-.]/_}
		CXXFLAGS=${!VAR-${CFLAGS}}
	fi
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

	# Translate our notion of multilibs into gcc's
	local abi list
	for abi in $(get_all_abis TARGET) ; do
		local l=$(gcc-abi-map ${abi})
		[[ -n ${l} ]] && list+=",${l}"
	done

	if [[ -n ${list} ]] ; then
		case ${CTARGET} in
			x86_64*)
				confgcc+=( --with-multilib-list=${list:1} )
			;;
		esac
	fi
}

gcc-abi-map() {
	# Convert the ABI name we use in Gentoo to what gcc uses
	local map=()
	case ${CTARGET} in
		mips*)
			map=("o32 32" "n32 n32" "n64 64")
			;;
		riscv*)
			map=("lp64d lp64d" "lp64 lp64" "ilp32d ilp32d" "ilp32 ilp32")
			;;
		x86_64*)
			map=("amd64 m64" "x86 m32" "x32 mx32")
			;;
	esac

	local m
	for m in "${map[@]}" ; do
		l=( ${m} )
		[[ $1 == ${l[0]} ]] && echo ${l[1]} && break
	done
}

#----> src_compile <----

toolchain_src_compile() {
	touch "${S}"/gcc/c-gperf.h || die

	# Do not make manpages if we do not have perl ...
	[[ ! -x "${BROOT}"/usr/bin/perl ]] \
		&& find "${WORKDIR}"/build -name '*.[17]' -exec touch {} +

	# To compile ada library standard files special compiler options are passed
	# via ADAFLAGS in the Makefile.
	# Unset ADAFLAGS as setting this override the options
	unset ADAFLAGS

	# Older gcc versions did not detect bash and re-exec itself, so force the
	# use of bash for them.
	# This needs to be set for compile as well, as it's used in libtool
	# generation, which will break install otherwise (at least in 3.3.6): bug #664486
	local gcc_shell="${BROOT}"/bin/bash
	if tc_version_is_at_least 11.2 ; then
		gcc_shell="${BROOT}"/bin/sh
	fi

	CONFIG_SHELL="${gcc_shell}" \
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
		# 3 stage bootstrapping doesn't quite work when you can't run the
		# resulting binaries natively
		GCC_MAKE_TARGET=${GCC_MAKE_TARGET-all}
	else
		if [[ ${EXTRA_ECONF} == *--disable-bootstrap* ]] ; then
			GCC_MAKE_TARGET=${GCC_MAKE_TARGET-all}

			ewarn "Disabling bootstrapping. ONLY recommended for development."
			ewarn "This is NOT a safe configuration for end users!"
			ewarn "This compiler may not be safe or reliable for production use!"
		elif _tc_use_if_iuse pgo; then
			GCC_MAKE_TARGET=${GCC_MAKE_TARGET-profiledbootstrap}
		else
			GCC_MAKE_TARGET=${GCC_MAKE_TARGET-bootstrap-lean}
		fi
	fi

	local emakeargs=(
		LDFLAGS="${LDFLAGS}"
		LIBPATH="${LIBPATH}"
	)

	if is_crosscompile; then
		# In 3.4, BOOT_CFLAGS is never used on a crosscompile...
		# but I'll leave this in anyways as someone might have had
		# some reason for putting it in here... --eradicator
		BOOT_CFLAGS=${BOOT_CFLAGS-"-O2"}
		emakeargs+=( BOOT_CFLAGS="${BOOT_CFLAGS}" )
	else
		# XXX: Hack for bug #914881, clean this up when fixed and go back
		# to just calling get_abi_LDFLAGS as before.
		local abi_ldflags="$(get_abi_LDFLAGS ${TARGET_DEFAULT_ABI})"
		if [[ -n ${abi_ldflags} ]] ; then
			printf -v abi_ldflags -- "-Wl,%s " ${abi_ldflags}
		fi

		# If the host compiler is too old, let's use -O0 per the upstream
		# default to be safe (to avoid a bootstrap comparison failure later).
		#
		# The last known issues are with < GCC 4.9 or so, but it's easier
		# to keep this bound somewhat fresh just to avoid problems. Ultimately,
		# using not-O0 is just a build-time speed improvement anyway.
		if ! tc-is-gcc || ver_test $(gcc-fullversion) -lt 10 ; then
			STAGE1_CFLAGS="-O0"
		fi

		# We only want to use the system's CFLAGS if not building a
		# cross-compiler.
		STAGE1_CFLAGS=${STAGE1_CFLAGS-"$(get_abi_CFLAGS ${TARGET_DEFAULT_ABI}) ${CFLAGS}"}
		STAGE1_LDFLAGS=${STAGE1_LDFLAGS-"${abi_ldflags} ${LDFLAGS}"}
		BOOT_CFLAGS=${BOOT_CFLAGS-"$(get_abi_CFLAGS ${TARGET_DEFAULT_ABI}) ${CFLAGS}"}
		BOOT_LDFLAGS=${BOOT_LDFLAGS-"${abi_ldflags} ${LDFLAGS}"}
		LDFLAGS_FOR_TARGET="${LDFLAGS_FOR_TARGET:-${LDFLAGS}}"

		emakeargs+=(
			STAGE1_CFLAGS="${STAGE1_CFLAGS}"
			STAGE1_LDFLAGS="${STAGE1_LDFLAGS}"
			BOOT_CFLAGS="${BOOT_CFLAGS}"
			BOOT_LDFLAGS="${BOOT_LDFLAGS}"
			LDFLAGS_FOR_TARGET="${LDFLAGS_FOR_TARGET}"
		)
	fi

	if is_jit ; then
		# TODO: docs for jit?
		einfo "Building JIT"
		emake -C "${WORKDIR}"/build-jit "${emakeargs[@]}"
	fi

	einfo "Compiling ${PN} (${GCC_MAKE_TARGET})..."
	pushd "${WORKDIR}"/build >/dev/null || die
	emake "${emakeargs[@]}" ${GCC_MAKE_TARGET}

	if is_ada; then
		# Without these links, it is not getting the good compiler
		# TODO: Need to check why
		ln -s gcc ../build/prev-gcc || die
		ln -s ${CHOST} ../build/prev-${CHOST} || die

		# Building standard ada library
		emake -C gcc gnatlib-shared
		# Building gnat toold
		emake -C gcc gnattools
	fi

	if ! is_crosscompile && _tc_use_if_iuse cxx && _tc_use_if_iuse doc ; then
		if type -p doxygen > /dev/null ; then
			cd "${CTARGET}"/libstdc++-v3/doc || die
			emake doc-man-doxygen

			# Clean bogus manpages. bug #113902
			find -name '*_build_*' -delete || die

			# Blow away generated directory references. Newer versions of gcc
			# have gotten better at this, but not perfect. This is easier than
			# backporting all of the various doxygen patches. bug #486754
			find -name '*_.3' -exec grep -l ' Directory Reference ' {} + | \
				xargs rm -f
		else
			ewarn "Skipping libstdc++ manpage generation since you don't have doxygen installed"
		fi
	fi

	popd >/dev/null || die
}

#---->> src_test <<----

# TODO: add JIT testing
toolchain_src_test() {
	# GCC's testsuite is a special case.
	#
	# * Generally, people work off comparisons rather than a full set of
	#   passing tests.
	#
	# * The guality (sic) tests are for debug info quality and are especially
	#   unreliable.
	#
	# * The execute torture tests are hopefully a good way for us to smoketest
	#   and find critical regresions.

	# From opensuse's spec file: "asan needs a whole shadow address space"
	ulimit -v unlimited

	# 'asan' wants to be preloaded first, so does 'sandbox'.
	# To make asan tests work, we disable sandbox for all of test suite.
	# The 'backtrace' tests also do not like the presence of 'libsandbox.so'.
	local -x SANDBOX_ON=0
	local -x LD_PRELOAD=

	# Controls running expensive tests in e.g. the torture testsuite.
	# Note that 'TEST', not 'TESTS', is correct here as it's a GCC
	# testsuite variable, not ours.
	local -x GCC_TEST_RUN_EXPENSIVE=1

	# Use a subshell to allow meddling with flags just for the testsuite
	(
		# Unexpected warnings confuse the tests.
		filter-flags -W*
		# May break parsing.
		filter-flags '-fdiagnostics-color=*' '-fdiagnostics-urls=*'
		# Gentoo QA flags which don't belong in tests
		filter-flags -frecord-gcc-switches
		filter-flags '-Wl,--defsym=__gentoo_check_ldflags__=0'
		# Go doesn't support this and causes noisy warnings
		filter-flags -Wbuiltin-declaration-mismatch
		# The ASAN tests at least need LD_PRELOAD and the contract
		# tests.
		filter-flags -fno-semantic-interposition

		# Workaround our -Wformat-security default which breaks
		# various tests as it adds unexpected warning output.
		GCC_TESTS_CFLAGS+=" -Wno-format-security -Wno-format"
		GCC_TESTS_CXXFLAGS+=" -Wno-format-security -Wno-format"

		# Workaround our -Wtrampolines default which breaks
		# tests too.
		GCC_TESTS_CFLAGS+=" -Wno-trampolines"
		GCC_TESTS_CXXFLAGS+=" -Wno-trampolines"
		# A handful of Ada (and objc++?) tests need an executable stack
		GCC_TESTS_LDFLAGS+=" -Wl,--no-warn-execstack"
		# Avoid confusing tests like Fortran/C interop ones where
		# CFLAGS are used.
		GCC_TESTS_CFLAGS+=" -Wno-complain-wrong-lang"
		GCC_TESTS_CXXFLAGS+=" -Wno-complain-wrong-lang"

		# Issues with Ada tests:
		# gnat.dg/align_max.adb
		# gnat.dg/trampoline4.adb
		#
		# A handful of Ada tests use -fstack-check and conflict
		# with -fstack-clash-protection.
		#
		# TODO: This isn't ideal given it obv. affects codegen
		# and we want to be sure it works.
		GCC_TESTS_CFLAGS+=" -fno-stack-clash-protection"
		GCC_TESTS_CXXFLAGS+=" -fno-stack-clash-protection"

		# configure defaults to '-O2 -g' and some tests expect it
		# accordingly.
		GCC_TESTS_CFLAGS+=" -g"

		# TODO: Does this handle s390 (-m31) correctly?
		# TODO: What if there are multiple ABIs like x32 too?
		# XXX: Disabled until validate_failures.py can handle 'variants'
		# XXX: https://gcc.gnu.org/PR116260
		#is_multilib && GCC_TESTS_RUNTESTFLAGS+=" --target_board=unix{,-m32}"

		# nonfatal here as we die if the comparison below fails. Also, note that
		# the exit code of targets other than 'check' may be unreliable.
		#
		# CFLAGS and so on are repeated here because of tests vs building test
		# deps like libbacktrace.
		nonfatal emake -C "${WORKDIR}"/build -k "${GCC_TESTS_CHECK_TARGET}" \
			RUNTESTFLAGS=" \
				${GCC_TESTS_RUNTESTFLAGS} \
				CFLAGS_FOR_TARGET='${GCC_TESTS_CFLAGS_FOR_TARGET:-${GCC_TESTS_CFLAGS}}' \
				CXXFLAGS_FOR_TARGET='${GCC_TESTS_CXXFLAGS_FOR_TARGET:-${GCC_TESTS_CXXFLAGS}}' \
				LDFLAGS_FOR_TARGET='${TEST_LDFLAGS_FOR_TARGET:-${GCC_TESTS_LDFLAGS}}' \
				CFLAGS='${GCC_TESTS_CFLAGS}' \
				CXXFLAGS='${GCC_TESTS_CXXFLAGS}' \
				FCFLAGS='${GCC_TESTS_FCFLAGS}' \
				FFLAGS='${GCC_TESTS_FFLAGS}' \
				LDFLAGS='${GCC_TESTS_LDFLAGS}' \
			" \
			CFLAGS_FOR_TARGET="${GCC_TESTS_CFLAGS_FOR_TARGET:-${GCC_TESTS_CFLAGS}}" \
			CXXFLAGS_FOR_TARGET="${GCC_TESTS_CXXFLAGS_FOR_TARGET:-${GCC_TESTS_CXXFLAGS}}" \
			LDFLAGS_FOR_TARGET="${GCC_TESTS_LDFLAGS_FOR_TARGET:-${GCC_TESTS_LDFLAGS}}" \
			CFLAGS="${GCC_TESTS_CFLAGS}" \
			CXXFLAGS="${GCC_TESTS_CXXFLAGS}" \
			FCFLAGS="${GCC_TESTS_FCFLAGS}" \
			FFLAGS="${GCC_TESTS_FFLAGS}" \
			LDFLAGS="${GCC_TESTS_LDFLAGS}"
	)

	# Produce an updated failure manifest.
	einfo "Generating a new failure manifest ${T}/${CHOST}.xfail"
	rm -f "${T}"/${CHOST}.xfail
	edo "${T}"/validate_failures.py \
		--srcpath="${S}" \
		--build_dir="${WORKDIR}"/build \
		--manifest="${T}"/${CHOST}.xfail \
		--produce_manifest &> /dev/null

	# If there's no manifest available, check older slots, as it's better
	# than nothing. We start with 10 for the fallback as the first version
	# we started using --with-major-version-only.
	local possible_slot
	for possible_slot in "${GCC_TESTS_COMPARISON_SLOT}" $(seq ${SLOT} -1 10) ; do
		[[ -f "${GCC_TESTS_COMPARISON_DIR}/${possible_slot}/${CHOST}.xfail" ]] && break
	done
	if [[ ${possible_slot} != "${GCC_TESTS_COMPARISON_SLOT}" ]] ; then
		ewarn "Couldn't find manifest for ${GCC_TESTS_COMPARISON_SLOT}; falling back to ${possible_slot}"
	fi
	local manifest="${GCC_TESTS_COMPARISON_DIR}/${possible_slot}/${CHOST}.xfail"

	if [[ -f "${manifest}" ]] ; then
		# TODO: Distribute some baseline results in e.g. gcc-patches.git?
		# validate_failures.py manifest files support include directives.
		einfo "Comparing with previous cached results at ${manifest}"

		nonfatal edo "${T}"/validate_failures.py \
			--srcpath="${S}" \
			--build_dir="${WORKDIR}"/build \
			--manifest="${manifest}"
		ret=$?

		if [[ -n ${GCC_TESTS_REGEN_BASELINE} ]] ; then
			eerror "GCC_TESTS_REGEN_BASELINE is set, ignoring test result and creating a new baseline..."
		elif [[ ${ret} != 0 ]]; then
			die "Tests failed (failures not listed in the baseline data)"
		fi
	else
		nonfatal edo "${T}"/validate_failures.py \
			--srcpath="${S}" \
			--build_dir="${WORKDIR}"/build
		ret=$?

		# We have no reference data saved from a previous run to know if
		# the failures are tolerable or not, so we bail out.
		eerror "No reference test data at ${manifest}!"
		eerror "GCC's tests require a baseline to compare with for any reasonable interpretation of results."

		if [[ -n ${GCC_TESTS_IGNORE_NO_BASELINE} ]] ; then
			eerror "GCC_TESTS_IGNORE_NO_BASELINE is set, ignoring test result and creating a new baseline..."
		elif [[ -n ${GCC_TESTS_REGEN_BASELINE} ]] ; then
			eerror "GCC_TESTS_REGEN_BASELINE is set, ignoring test result and creating using a new baseline..."
		elif [[ ${ret} != 0 ]] ; then
			eerror "(Set GCC_TESTS_IGNORE_NO_BASELINE=1 to make this non-fatal and generate a baseline.)"
			die "Tests failed (failures occurred with no reference data)"
		fi
	fi
}

#---->> src_install <<----

toolchain_src_install() {
	cd "${WORKDIR}"/build || die

	# Don't allow symlinks in private gcc include dir as this can break the build
	find gcc/include*/ -type l -delete || die

	if [[ ${GCC_RUN_FIXINCLUDES} == 0 ]] ; then
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
	fi

	if is_jit ; then
		# See https://gcc.gnu.org/onlinedocs/gcc-11.3.0/jit/internals/index.html#packaging-notes
		# and bug #843341.
		#
		# Both of the non-JIT and JIT builds are configured to install to $(DESTDIR)
		# Install the configuration with --enable-host-shared first
		# *then* the one without, so that the faster build
		# of "cc1" et al overwrites the slower build.
		#
		# Do the 'make install' from the build directory
		pushd "${WORKDIR}"/build-jit > /dev/null || die
		S="${WORKDIR}"/build-jit emake DESTDIR="${D}" -j1 install

		# Punt some tools which are really only useful while building gcc
		find "${ED}" -name install-tools -prune -type d -exec rm -rf "{}" \; || die
		# This one comes with binutils
		find "${ED}" -name libiberty.a -delete || die

		# Move the libraries to the proper location
		gcc_movelibs

		popd > /dev/null || die
	fi

	# Do the 'make install' from the build directory
	#
	# Unfortunately, we have to use -j1 for make install. Upstream
	# don't really test it and there's not much appetite for fixing bugs
	# with it. Several reported bugs exist where the resulting image
	# was wrong, rather than a simple compile/install failure:
	# - bug #906155
	# - https://gcc.gnu.org/PR42980
	# - https://gcc.gnu.org/PR51814
	# - https://gcc.gnu.org/PR103656
	# - https://gcc.gnu.org/PR109898
	S="${WORKDIR}"/build emake DESTDIR="${D}" -j1 install

	# Punt some tools which are really only useful while building gcc
	find "${ED}" -name install-tools -prune -type d -exec rm -rf "{}" \; || die
	# This one comes with binutils
	find "${ED}" -name libiberty.a -delete || die

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

	dodir /usr/bin
	cd "${D}"${BINPATH} || die
	# Ugh: we really need to auto-detect this list.
	#      It's constantly out of date.
	for x in cpp gcc gccrs g++ c++ gcov g77 gfortran gccgo gnat* ; do
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
				dosym ${BINPATH}/${CTARGET}-${x} \
					/usr/bin/${x}-${GCC_CONFIG_VER}
			fi
			# Create versioned symlinks
			dosym ${BINPATH}/${CTARGET}-${x} \
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
		# when gcc-config runs. bug #567806
		if is_go ; then
			for x in go gofmt; do
				mv ${x} ${x}-${GCCMAJOR} || die
			done
		fi
	fi

	# As gcc installs object files built against both ${CHOST} and ${CTARGET}
	# ideally we will need to strip them using different tools:
	# Using ${CHOST} tools:
	#  - "${D}${BINPATH}"
	#  - (for is_crosscompile) "${D}${HOSTLIBPATH}"
	#  - "${D}${PREFIX}/libexec/gcc/${CTARGET}/${GCC_CONFIG_VER}"
	# Using ${CTARGET} tools:
	#  - "${D}${LIBPATH}"
	# As dostrip does not specify host to override ${CHOST} tools just skip
	# non-native binary stripping.
	is_crosscompile && dostrip -x "${LIBPATH}"

	cd "${S}" || die
	if is_crosscompile; then
		rm -rf "${ED}"/usr/share/{man,info}
		rm -rf "${D}"${DATAPATH}/{man,info}
	else
		local cxx_mandir=$(find "${WORKDIR}/build/${CTARGET}/libstdc++-v3" -name man || die)
		if [[ -d ${cxx_mandir} ]] ; then
			cp -r "${cxx_mandir}"/man? "${D}${DATAPATH}"/man/ || die
		fi
	fi

	# Portage regenerates 'dir' files on its own: bug #672408
	# Drop 'dir' files to avoid collisions.
	if [[ -f "${D}${DATAPATH}"/info/dir ]]; then
		einfo "Deleting '${D}${DATAPATH}/info/dir'"
		rm "${D}${DATAPATH}"/info/dir || die
	fi

	docompress "${DATAPATH}"/{info,man}

	# Prune empty dirs left behind. It's fine not to die here as we may
	# really have no empty dirs left.
	find "${ED}" -depth -type d -delete 2>/dev/null

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
	# dynamic & static case (libgfortran.spec). bug #573302
	# libgfortranbegin.la: Same as above, and it's an internal lib.
	# libitm.la: gcc itself handles linkage correctly (libitm.spec).
	# libvtv.la: gcc itself handles linkage correctly.
	# lib*san.la: Sanitizer linkage is handled internally by gcc, and they
	# do not support static linking. bug #487550, bug #546700
	find "${D}${LIBPATH}" \
		'(' \
			-name libstdc++.la -o \
			-name libstdc++fs.la -o \
			-name libstdc++exp.la -o \
			-name libsupc++.la -o \
			-name libcc1.la -o \
			-name libcc1plugin.la -o \
			-name libcp1plugin.la -o \
			-name 'libgomp.la' -o \
			-name 'libgomp-plugin-*.la' -o \
			-name libgfortran.la -o \
			-name libgfortranbegin.la -o \
			-name libitm.la -o \
			-name libvtv.la -o \
			-name 'lib*san.la' \
		')' -type f -delete || die

	# Use gid of 0 because some stupid ports don't have
	# the group 'root' set to gid 0.  Send to /dev/null
	# for people who are testing as non-root.
	chown -R 0:0 "${D}${LIBPATH}" 2>/dev/null || die

	# Installing gdb pretty-printers into gdb-specific location.
	local py gdbdir=/usr/share/gdb/auto-load${LIBPATH}
	pushd "${D}${LIBPATH}" >/dev/null || die
	for py in $(find . -name '*-gdb.py' || die) ; do
		local multidir=${py%/*}

		insinto "${gdbdir}/${multidir}"
		# bug #348128
		sed -i "/^libdir =/s:=.*:= '${LIBPATH}/${multidir}':" "${py}" || die
		doins "${py}"

		rm "${py}" || die
	done
	popd >/dev/null || die

	# Don't scan .gox files for executable stacks - false positives
	export QA_EXECSTACK="usr/lib*/go/*/*.gox"
	export QA_WX_LOAD="usr/lib*/go/*/*.gox"

	# Disable RANDMMAP so PCH works, bug #301299
	pax-mark -r "${ED}/libexec/gcc/${CTARGET}/${GCC_CONFIG_VER}/cc1"
	pax-mark -r "${ED}/libexec/gcc/${CTARGET}/${GCC_CONFIG_VER}/cc1plus"

	if use test ; then
		mkdir "${T}"/test-results || die
		cd "${WORKDIR}"/build || die
		find . -name \*.sum -exec cp --parents -v {} "${T}"/test-results \; || die
	fi
}

# Move around the libs to the right location.  For some reason,
# when installing gcc, it dumps internal libraries into /usr/lib
# instead of the private gcc lib path
gcc_movelibs() {
	# For non-target libs which are for CHOST and not CTARGET, we want to
	# move them to the compiler-specific CHOST internal dir.  This is stuff
	# that you want to link against when building tools rather than building
	# code to run on the target.
	if is_crosscompile ; then
		dodir "${HOSTLIBPATH#${EPREFIX}}"
		mv "${ED}"/usr/$(get_libdir)/libcc1* "${D}${HOSTLIBPATH}" || die
	fi

	# libgccjit gets installed to /usr/lib, not /usr/$(get_libdir). Probably
	# due to a bug in gcc build system.
	if [[ ${PWD} == "${WORKDIR}"/build-jit ]] && is_jit ; then
		dodir "${LIBPATH#${EPREFIX}}"
		mv "${ED}"/usr/lib/libgccjit* "${D}${LIBPATH}" || die
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
				local files=$(find "${FROMDIR}" -maxdepth 1 ! -type d 2>/dev/null || die)
				if [[ -n ${files} ]] ; then
					mv ${files} "${TODIR}" || die
				fi
			fi
		done
		fix_libtool_libdir_paths "${LIBPATH}/${MULTIDIR}"
	done

	# We remove directories separately to avoid this case:
	#	mv SRC/lib/../lib/*.o DEST
	#	rmdir SRC/lib/../lib/
	#	mv SRC/lib/../lib32/*.o DEST  # Bork
	for FROMDIR in ${removedirs} ; do
		rmdir "${D}"${FROMDIR} >& /dev/null
	done
	# XXX: Intentionally no die, here to remove empty dirs
	find -depth "${ED}" -type d -exec rmdir {} + >& /dev/null
}

# Make sure the libtool archives have libdir set to where they actually
# -are-, and not where they -used- to be. Also, any dependencies we have
# on our own .la files need to be updated.
fix_libtool_libdir_paths() {
	local libpath="$1"

	pushd "${D}" >/dev/null || die

	pushd "./${libpath}" >/dev/null || die
	local dir="${PWD#${D%/}}"
	local allarchives=$(echo *.la)
	allarchives="\(${allarchives// /\\|}\)"
	popd >/dev/null || die

	# The libdir might not have any .la files. bug #548782
	find "./${dir}" -maxdepth 1 -name '*.la' \
		-exec sed -i -e "/^libdir=/s:=.*:='${dir}':" {} + || die
	# Would be nice to combine these, but -maxdepth can not be specified
	# on sub-expressions.
	find "./${PREFIX}"/lib* -maxdepth 3 -name '*.la' \
		-exec sed -i -e "/^dependency_libs=/s:/[^ ]*/${allarchives}:${libpath}/\1:g" {} + || die
	find "./${dir}/" -maxdepth 1 -name '*.la' \
		-exec sed -i -e "/^dependency_libs=/s:/[^ ]*/${allarchives}:${libpath}/\1:g" {} + || die

	popd >/dev/null || die
}

create_gcc_env_entry() {
	dodir /etc/env.d/gcc

	local gcc_envd_base="/etc/env.d/gcc/${CTARGET}-${GCC_CONFIG_VER}"
	local gcc_specs_file
	local gcc_envd_file="${ED}${gcc_envd_base}"
	if [[ -z $1 ]] ; then
		# I'm leaving the following commented out to remind me that it
		# was an insanely -bad- idea. Stuff broke. GCC_SPECS isn't unset
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
	local mdir mosdir abi ldpath
	for abi in $(get_all_abis TARGET) ; do
		mdir=$($(XGCC) $(get_abi_CFLAGS ${abi}) --print-multi-directory)
		ldpath=${LIBPATH}
		[[ ${mdir} != "." ]] && ldpath+="/${mdir}"
		ldpaths="${ldpath}${ldpaths:+:${ldpaths}}"

		mosdir=$($(XGCC) $(get_abi_CFLAGS ${abi}) -print-multi-os-directory)
		mosdirs="${mosdir}${mosdirs:+:${mosdirs}}"
	done

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

#---->> pkg_pre* <<----

toolchain_pkg_preinst() {
	if [[ ${MERGE_TYPE} != binary ]] && use test ; then
		# Install as orphaned to allow comparison across more versions even
		# after unmerged. Also useful for historical records and tracking
		# down regressions a while after they first appeared, but were only
		# just reported.
		einfo "Copying test results to ${GCC_TESTS_COMPARISON_DIR}/${SLOT}/${CHOST}.xfail for future comparison"
		(
			mkdir -p "${GCC_TESTS_COMPARISON_DIR}/${SLOT}" || die
			cd "${T}"/test-results || die
			# May not exist with test-fail-continue
			if [[ -f "${T}"/${CHOST}.xfail ]] ; then
				cp -v "${T}"/${CHOST}.xfail "${GCC_TESTS_COMPARISON_DIR}/${SLOT}" || die
			fi
		)
	fi
}

#---->> pkg_post* <<----

toolchain_pkg_postinst() {
	do_gcc_config

	if [[ ! ${ROOT} && -f ${EPREFIX}/usr/share/eselect/modules/compiler-shadow.eselect ]] ; then
		eselect compiler-shadow update all
	fi

	if ! is_crosscompile && [[ ${PN} != "kgcc64" ]] ; then
		# gcc stopped installing .la files fixer in June 2020.
		# Cleaning can be removed in June 2022.
		rm -f "${EROOT}"/sbin/fix_libtool_files.sh
		rm -f "${EROOT}"/usr/sbin/fix_libtool_files.sh
		rm -f "${EROOT}"/usr/share/gcc-data/fixlafiles.awk
	fi
}

toolchain_pkg_postrm() {
	do_gcc_config
	if [[ ! ${ROOT} && -f ${EPREFIX}/usr/share/eselect/modules/compiler-shadow.eselect ]] ; then
		eselect compiler-shadow clean all
	fi

	# Clean up the cruft left behind by cross-compilers
	if is_crosscompile ; then
		if [[ -z $(ls "${EROOT}"/etc/env.d/gcc/${CTARGET}* 2>/dev/null) ]] ; then
			einfo "Removing last cross-compiler instance. Deleting dangling symlinks."
			rm -f "${EROOT}"/etc/env.d/gcc/config-${CTARGET}
			rm -f "${EROOT}"/etc/env.d/??gcc-${CTARGET}
			rm -f "${EROOT}"/usr/bin/${CTARGET}-{gcc,{g,c}++}{,32,64}
		fi
		return 0
	fi

	# gcc stopped installing .la files fixer in June 2020.
	# Cleaning can be removed in June 2022.
	rm -f "${EROOT}"/sbin/fix_libtool_files.sh
	rm -f "${EROOT}"/usr/share/gcc-data/fixlafiles.awk
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
		# Figure out which specs-specific config is active
		current_specs=$(gcc-config -S ${current_gcc_config} | awk '{print $3}')
		[[ -n ${current_specs} ]] && use_specs=-${current_specs}

		if [[ -n ${use_specs} ]] && \
		   [[ ! -e ${EROOT}/etc/env.d/gcc/${CTARGET}-${GCC_CONFIG_VER}${use_specs} ]]
		then
			ewarn "The currently selected specs-specific gcc config,"
			ewarn "${current_specs}, doesn't exist anymore. This is usually"
			ewarn "due to enabling/disabling hardened or switching to a version"
			ewarn "of gcc that doesn't create multiple specs files. The default"
			ewarn "config will be used, and the previous preference forgotten."
			use_specs=""
		fi

		target="${CTARGET}-${GCC_CONFIG_VER}${use_specs}"
	else
		# The current target is invalid.  Attempt to switch to a valid one.
		# Blindly pick the latest version. bug #529608
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

	# If the previously selected config has the same major.minor (branch) as
	# the version we are installing, then it will probably be uninstalled
	# for being in the same SLOT, so make sure we run gcc-config.
	local curr_config_ver=$(gcc-config -S ${curr_config} | awk '{print $2}')

	local curr_branch_ver=$(ver_cut 1-2 ${curr_config_ver})

	if tc_use_major_version_only && [[ ${curr_config_ver} == ${GCCMAJOR} ]] ; then
		return 0
	elif ! tc_use_major_version_only && [[ ${curr_branch_ver} == ${GCC_BRANCH_VER} ]] ; then
		return 0
	else
		# If we're installing a genuinely different compiler version,
		# we should probably tell the user -how- to switch to the new
		# gcc version, since we're not going to do it for them.
		#
		# We don't want to switch from say gcc-3.3 to gcc-3.4 right in
		# the middle of an emerge operation (like an 'emerge -e world'
		# which could install multiple gcc versions).
		#
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
# language that doesn't exist. GCC 3.4 supports f77, while 4.0 supports f95, etc.
#
# Also add a hook so special ebuilds (kgcc64) can control which languages
# exactly get enabled
gcc-lang-supported() {
	grep ^language=\"${1}\" "${S}"/gcc/*/config-lang.in > /dev/null || return 1
	[[ -z ${TOOLCHAIN_ALLOWED_LANGS} ]] && return 0
	has $1 ${TOOLCHAIN_ALLOWED_LANGS}
}

_tc_use_if_iuse() {
	in_iuse $1 && use $1
}

is_ada() {
	gcc-lang-supported ada || return 1
	_tc_use_if_iuse cxx && _tc_use_if_iuse ada
}

is_cxx() {
	gcc-lang-supported 'c++' || return 1
	_tc_use_if_iuse cxx
}

is_d() {
	gcc-lang-supported d || return 1
	_tc_use_if_iuse d
}

is_f77() {
	gcc-lang-supported f77 || return 1
	_tc_use_if_iuse fortran
}

is_f95() {
	gcc-lang-supported f95 || return 1
	_tc_use_if_iuse fortran
}

is_fortran() {
	gcc-lang-supported fortran || return 1
	_tc_use_if_iuse fortran
}

is_go() {
	gcc-lang-supported go || return 1
	_tc_use_if_iuse cxx && _tc_use_if_iuse go
}

is_jit() {
	gcc-lang-supported jit || return 1

	# cross-compiler does not really support jit as it has
	# to generate code for a target. On targets like avr,
	# libgcclit.so can't link at all: bug #594572
	is_crosscompile && return 1

	_tc_use_if_iuse jit
}

is_multilib() {
	_tc_use_if_iuse multilib
}

is_objc() {
	gcc-lang-supported objc || return 1
	_tc_use_if_iuse objc
}

is_objcxx() {
	gcc-lang-supported 'obj-c++' || return 1
	_tc_use_if_iuse cxx && _tc_use_if_iuse objc++
}

is_modula2() {
	gcc-lang-supported m2 || return 1
	_tc_use_if_iuse cxx && _tc_use_if_iuse modula2
}

is_rust() {
	gcc-lang-supported rust || return 1
	_tc_use_if_iuse rust
}

# Grab a variable from the build system (taken from linux-info.eclass)
get_make_var() {
	local var=$1 makefile=${2:-${WORKDIR}/build/Makefile}
	echo -e "e:\\n\\t@echo \$(${var})\\ninclude ${makefile}" | \
		r=${makefile%/*} emake --no-print-directory -s -f - 2>/dev/null
}

XGCC() { get_make_var GCC_FOR_TARGET ; }

has toolchain_death_notice ${EBUILD_DEATH_HOOKS} || EBUILD_DEATH_HOOKS+=" toolchain_death_notice"
toolchain_death_notice() {
	if [[ -e "${WORKDIR}"/build ]] ; then
		pushd "${WORKDIR}"/build >/dev/null
		(echo '' | $(tc-getCC ${CTARGET}) ${CFLAGS} -v -E - 2>&1) > gccinfo.log
		[[ -e "${T}"/build.log ]] && cp "${T}"/build.log .
		tar -acf "${WORKDIR}"/gcc-build-logs.tar.xz \
			gccinfo.log build.log $(find -name config.log)
		rm gccinfo.log build.log
		eerror
		eerror "Please include ${WORKDIR}/gcc-build-logs.tar.xz in your bug report."
		eerror
		popd >/dev/null
	fi
}

fi

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

EXPORT_FUNCTIONS pkg_pretend pkg_setup src_unpack src_prepare src_configure src_compile src_test src_install pkg_preinst pkg_postinst pkg_postrm
