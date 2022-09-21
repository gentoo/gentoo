# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: llvm.org.eclass
# @MAINTAINER:
# Michał Górny <mgorny@gentoo.org>
# @AUTHOR:
# Michał Górny <mgorny@gentoo.org>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Common bits for fetching & unpacking llvm.org projects
# @DESCRIPTION:
# The llvm.org eclass provides common code to fetch and unpack parts
# of the llvm.org project tree.  It takes care of handling both git
# checkouts and source tarballs, making it possible to unify the code
# of live and release ebuilds and effectively reduce the work needed
# to package new releases/RCs/branches.
#
# In order to use this eclass, the ebuild needs to declare
# LLVM_COMPONENTS and then call llvm.org_set_globals.  If tests require
# additional components, they need to be listed in LLVM_TEST_COMPONENTS.
# The eclass exports an implementation of src_unpack() phase.
#
# Example:
# @CODE
# inherit llvm.org
#
# LLVM_COMPONENTS=( lld )
# LLVM_TEST_COMPONENTS=( llvm/utils/lit )
# llvm.org_set_globals
# @CODE

case "${EAPI:-0}" in
	7|8)
		;;
	*)
		die "Unsupported EAPI=${EAPI} for ${ECLASS}"
		;;
esac


# == internal control bits ==

# @ECLASS_VARIABLE: _LLVM_MASTER_MAJOR
# @INTERNAL
# @DESCRIPTION:
# The major version of current LLVM trunk.  Used to determine
# the correct branch to use.
_LLVM_MASTER_MAJOR=16

# @ECLASS_VARIABLE: _LLVM_NEWEST_MANPAGE_RELEASE
# @INTERNAL
# @DESCRIPTION:
# The newest release of LLVM for which manpages were generated.
_LLVM_NEWEST_MANPAGE_RELEASE=15.0.1

# @ECLASS_VARIABLE: _LLVM_SOURCE_TYPE
# @INTERNAL
# @DESCRIPTION:
# Source type to use: 'git', 'tar' or 'snapshot'.
if [[ -z ${_LLVM_SOURCE_TYPE+1} ]]; then
	case ${PV} in
		*.9999)
			_LLVM_SOURCE_TYPE=git
			;;
		*_pre*)
			_LLVM_SOURCE_TYPE=snapshot

			case ${PV} in
				16.0.0_pre20220915)
					EGIT_COMMIT=02a27b38909edc46c41732f79a837c95c9992d5a
					;;
				16.0.0_pre20220918)
					EGIT_COMMIT=303526ef3aa211c1930be2885deae15eeeda3b18
					;;
				*)
					die "Unknown snapshot: ${PV}"
					;;
			esac
			;;
		*)
			_LLVM_SOURCE_TYPE=tar
			;;
	esac
fi

[[ ${_LLVM_SOURCE_TYPE} == git ]] && inherit git-r3

[[ ${PV} == ${_LLVM_MASTER_MAJOR}.* && ${_LLVM_SOURCE_TYPE} == tar ]] &&
	die "${ECLASS}: Release ebuild for master branch?!"

inherit multiprocessing

if ver_test -ge 14.0.5; then
	inherit verify-sig
fi


# == control variables ==

# @ECLASS_VARIABLE: LLVM_COMPONENTS
# @REQUIRED
# @DESCRIPTION:
# List of components needed unconditionally.  Specified as bash array
# with paths relative to llvm-project git.  Automatically translated
# for tarball releases.
#
# The first path specified is used to construct default S.

# @ECLASS_VARIABLE: LLVM_TEST_COMPONENTS
# @DEFAULT_UNSET
# @DESCRIPTION:
# List of additional components needed for tests.

# @ECLASS_VARIABLE: LLVM_MANPAGES
# @DEFAULT_UNSET
# @DESCRIPTION:
# Set to a non-empty value in ebuilds that build manpages via Sphinx.
# The eclass will either include the dependency on dev-python/sphinx
# or pull the pregenerated manpage tarball depending on the package
# version.

# @ECLASS_VARIABLE: LLVM_PATCHSET
# @DEFAULT_UNSET
# @DESCRIPTION:
# LLVM patchset version.  No patchset is used if unset.

# @ECLASS_VARIABLE: LLVM_USE_TARGETS
# @DEFAULT_UNSET
# @DESCRIPTION:
# Add LLVM_TARGETS flags.  The following values are supported:
#
# - provide - this package provides LLVM targets.  USE flags
#   and REQUIRED_USE will be added but no dependencies.
#
# - llvm - this package uses targets from LLVM.  RDEPEND+DEPEND
#   on matching sys-devel/llvm versions with requested flags will
#   be added.
#
# Note that you still need to pass enabled targets to the build system,
# usually grabbing them from ${LLVM_TARGETS} (via USE_EXPAND).


# == global data ==

# @ECLASS_VARIABLE: ALL_LLVM_EXPERIMENTAL_TARGETS
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# The complete list of LLVM experimental targets available in this LLVM
# version.  The value depends on ${PV}.

# @ECLASS_VARIABLE: ALL_LLVM_PRODUCTION_TARGETS
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# The complete list of LLVM production-ready targets available in this
# LLVM version.  The value depends on ${PV}.

# @ECLASS_VARIABLE: ALL_LLVM_TARGET_FLAGS
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# The list of USE flags corresponding to all LLVM targets in this LLVM
# version.  The value depends on ${PV}.

case ${PV} in
	10*|11*|12*)
		# this API is not present for old LLVM versions
		;;
	13*)
		ALL_LLVM_EXPERIMENTAL_TARGETS=( ARC CSKY M68k VE )
		ALL_LLVM_PRODUCTION_TARGETS=(
			AArch64 AMDGPU ARM AVR BPF Hexagon Lanai Mips MSP430 NVPTX
			PowerPC RISCV Sparc SystemZ WebAssembly X86 XCore
		)
		;;
	14*)
		ALL_LLVM_EXPERIMENTAL_TARGETS=( ARC CSKY M68k )
		ALL_LLVM_PRODUCTION_TARGETS=(
			AArch64 AMDGPU ARM AVR BPF Hexagon Lanai Mips MSP430 NVPTX
			PowerPC RISCV Sparc SystemZ VE WebAssembly X86 XCore
		)
		;;
	*)
		ALL_LLVM_EXPERIMENTAL_TARGETS=(
			ARC CSKY DirectX LoongArch M68k SPIRV
		)
		ALL_LLVM_PRODUCTION_TARGETS=(
			AArch64 AMDGPU ARM AVR BPF Hexagon Lanai Mips MSP430 NVPTX
			PowerPC RISCV Sparc SystemZ VE WebAssembly X86 XCore
		)
		;;
esac

ALL_LLVM_TARGET_FLAGS=(
	"${ALL_LLVM_PRODUCTION_TARGETS[@]/#/llvm_targets_}"
	"${ALL_LLVM_EXPERIMENTAL_TARGETS[@]/#/llvm_targets_}"
)


# == global scope logic ==

# @FUNCTION: llvm.org_set_globals
# @DESCRIPTION:
# Set global variables.  This must be called after setting LLVM_*
# variables used by the eclass.
llvm.org_set_globals() {
	if [[ $(declare -p LLVM_COMPONENTS) != "declare -a"* ]]; then
		die 'LLVM_COMPONENTS must be an array.'
	fi
	if declare -p LLVM_TEST_COMPONENTS &>/dev/null; then
		if [[ $(declare -p LLVM_TEST_COMPONENTS) != "declare -a"* ]]; then
			die 'LLVM_TEST_COMPONENTS must be an array.'
		fi
	fi

	case ${_LLVM_SOURCE_TYPE} in
		git)
			EGIT_REPO_URI="https://github.com/llvm/llvm-project.git"

			[[ ${PV} != ${_LLVM_MASTER_MAJOR}.* ]] &&
				EGIT_BRANCH="release/${PV%%.*}.x"
			;;
		tar)
			if ver_test -ge 14.0.5; then
				SRC_URI+="
					https://github.com/llvm/llvm-project/releases/download/llvmorg-${PV/_/-}/llvm-project-${PV/_/}.src.tar.xz
					verify-sig? (
						https://github.com/llvm/llvm-project/releases/download/llvmorg-${PV/_/-}/llvm-project-${PV/_/}.src.tar.xz.sig
					)
				"
				BDEPEND+="
					verify-sig? (
						>=sec-keys/openpgp-keys-llvm-15
					)
				"
				VERIFY_SIG_OPENPGP_KEY_PATH=${BROOT}/usr/share/openpgp-keys/llvm.asc
			else
				SRC_URI+="
					https://github.com/llvm/llvm-project/archive/llvmorg-${PV/_/-}.tar.gz
				"
			fi
			;;
		snapshot)
			SRC_URI+="
				https://github.com/llvm/llvm-project/archive/${EGIT_COMMIT}.tar.gz
					-> llvm-project-${EGIT_COMMIT}.tar.gz
			"
			;;
		*)
			die "Invalid _LLVM_SOURCE_TYPE: ${LLVM_SOURCE_TYPE}"
	esac

	S=${WORKDIR}/${LLVM_COMPONENTS[0]}

	if [[ -n ${LLVM_TEST_COMPONENTS+1} ]]; then
		IUSE+=" test"
		RESTRICT+=" !test? ( test )"
	fi

	if [[ ${LLVM_MANPAGES} ]]; then
		# use pregenerated tarball for releases
		# up to _LLVM_NEWEST_MANPAGE_RELEASE
		if llvm_manpage_dist_available; then
			IUSE+=" doc"
			SRC_URI+="
				!doc? (
					https://dev.gentoo.org/~mgorny/dist/llvm/llvm-${PV}-manpages.tar.bz2
				)
			"
		else
			IUSE+=" doc"
			# NB: this is not always the correct dep but it does no harm
			BDEPEND+=" dev-python/sphinx"
		fi
	fi

	if [[ -n ${LLVM_PATCHSET} ]]; then
		SRC_URI+="
			https://dev.gentoo.org/~mgorny/dist/llvm/llvm-gentoo-patchset-${LLVM_PATCHSET}.tar.xz"
	fi

	local x
	case ${LLVM_USE_TARGETS:-__unset__} in
		__unset__)
			;;
		provide|llvm)
			IUSE+=" ${ALL_LLVM_TARGET_FLAGS[*]}"
			REQUIRED_USE+=" || ( ${ALL_LLVM_TARGET_FLAGS[*]} )"
			;;&
		llvm)
			local dep=
			for x in "${ALL_LLVM_TARGET_FLAGS[@]}"; do
				dep+="
					${x}? ( ~sys-devel/llvm-${PV}[${x}] )"
			done
			RDEPEND+=" ${dep}"
			DEPEND+=" ${dep}"
			;;
	esac

	# === useful defaults for cmake-based packages ===

	# least intrusive of all
	CMAKE_BUILD_TYPE=RelWithDebInfo

	_LLVM_ORG_SET_GLOBALS_CALLED=1
}


# == phase functions ==

EXPORT_FUNCTIONS src_unpack src_prepare

# @FUNCTION: llvm.org_src_unpack
# @DESCRIPTION:
# Unpack or checkout requested LLVM components.
llvm.org_src_unpack() {
	if [[ ! ${_LLVM_ORG_SET_GLOBALS_CALLED} ]]; then
		die "llvm.org_set_globals must be called in global scope"
	fi

	local components=( "${LLVM_COMPONENTS[@]}" )
	if [[ ${LLVM_TEST_COMPONENTS+1} ]] && use test; then
		components+=( "${LLVM_TEST_COMPONENTS[@]}" )
	fi

	local archive=
	case ${_LLVM_SOURCE_TYPE} in
		git)
			git-r3_fetch
			git-r3_checkout '' . '' "${components[@]}"
			;;
		tar)
			archive=llvmorg-${PV/_/-}.tar.gz
			if ver_test -ge 14.0.5; then
				archive=llvm-project-${PV/_/}.src.tar.xz
				if use verify-sig; then
					verify-sig_verify_detached \
						"${DISTDIR}/${archive}" "${DISTDIR}/${archive}.sig"
				fi
			fi

			ebegin "Unpacking from ${archive}"
			if ver_test -ge 14.0.5; then
				tar -x -J -o --strip-components 1 \
					-f "${DISTDIR}/${archive}" \
					"${components[@]/#/${archive%.tar*}/}" || die
			else
				tar -x -z -o --strip-components 1 \
					-f "${DISTDIR}/${archive}" \
					"${components[@]/#/llvm-project-${archive%.tar*}/}" || die
			fi
			eend ${?}
			;;
		snapshot)
			archive=llvm-project-${EGIT_COMMIT}.tar.gz
			ebegin "Unpacking from ${archive}"
			tar -x -z -o --strip-components 1 \
				-f "${DISTDIR}/${archive}" \
				"${components[@]/#/${archive%.tar*}/}" || die
			eend ${?}
			;;
		*)
			die "Invalid _LLVM_SOURCE_TYPE: ${LLVM_SOURCE_TYPE}"
			;;
	esac

	# unpack all remaining distfiles
	local x
	for x in ${A}; do
		[[ ${x} != ${archive} ]] && unpack "${x}"
	done

	if [[ -n ${LLVM_PATCHSET} ]]; then
		local nocomp=$(grep -r -L "^Gentoo-Component:" \
			"${WORKDIR}/llvm-gentoo-patchset-${LLVM_PATCHSET}")
		if [[ -n ${nocomp} ]]; then
			die "Patches lacking Gentoo-Component found: ${nocomp}"
		fi

		# strip patches that don't match current components
		local IFS='|'
		grep -E -r -L "^Gentoo-Component:.*(${components[*]})" \
			"${WORKDIR}/llvm-gentoo-patchset-${LLVM_PATCHSET}" |
			xargs rm
		local status=( "${PIPESTATUS[@]}" )
		[[ ${status[1]} -ne 0 ]] && die "rm failed"
		[[ ${status[0]} -ne 0 ]] &&
			die "No patches in the patchset apply to the package"
	fi
}

# @FUNCTION: llvm.org_src_prepare
# @DESCRIPTION:
# Call appropriate src_prepare (cmake or default) depending on inherited
# eclasses.  Make sure that PATCHES and user patches are applied in top
# ${WORKDIR}, so that patches straight from llvm-project repository
# work correctly with -p1.
llvm.org_src_prepare() {
	if [[ -n ${LLVM_PATCHSET} ]]; then
		local PATCHES=(
			"${PATCHES[@]}"
			"${WORKDIR}/llvm-gentoo-patchset-${LLVM_PATCHSET}"
		)
	fi

	pushd "${WORKDIR}" >/dev/null || die
	if declare -f cmake_src_prepare >/dev/null; then
		CMAKE_USE_DIR=${S}
		if [[ ${EAPI} == 7 ]]; then
			# cmake eclasses force ${S} for default_src_prepare in EAPI 7
			# but use ${CMAKE_USE_DIR} for everything else
			local S=${WORKDIR}
		fi
		cmake_src_prepare
	else
		default_src_prepare
	fi
	popd >/dev/null || die
}


# == helper functions ==

# @ECLASS_VARIABLE: LIT_JOBS
# @USER_VARIABLE
# @DEFAULT_UNSET
# @DESCRIPTION:
# Number of test jobs to run simultaneously.  If unset, defaults
# to '-j' in MAKEOPTS.  If that is not found, default to nproc.

# @FUNCTION: get_lit_flags
# @DESCRIPTION:
# Get the standard recommended lit flags for running tests, in CMake
# list form (;-separated).
get_lit_flags() {
	echo "-vv;-j;${LIT_JOBS:-$(makeopts_jobs)}"
}

# @FUNCTION: llvm_manpage_dist_available
# @DESCRIPTION:
# Return true (0) if this LLVM version features prebuilt manpage
# tarball, false (1) otherwise.
llvm_manpage_dist_available() {
	[[ ${_LLVM_SOURCE_TYPE} == tar ]] &&
		ver_test "${PV}" -le "${_LLVM_NEWEST_MANPAGE_RELEASE}"
}

# @FUNCTION: llvm_are_manpages_built
# @DESCRIPTION:
# Return true (0) if manpages are going to be built from source,
# false (1) if preinstalled manpages will be used.
llvm_are_manpages_built() {
	use doc || ! llvm_manpage_dist_available
}

# @FUNCTION: llvm_install_manpages
# @DESCRIPTION:
# Install pregenerated manpages if available.  No-op otherwise.
llvm_install_manpages() {
	# install pre-generated manpages
	if ! llvm_are_manpages_built; then
		# (doman does not support custom paths)
		insinto "/usr/lib/llvm/${SLOT}/share/man/man1"
		doins "${WORKDIR}/llvm-${PV}-manpages/${LLVM_COMPONENTS[0]}"/*.1
	fi
}
