# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: llvm.org.eclass
# @MAINTAINER:
# Michał Górny <mgorny@gentoo.org>
# @AUTHOR:
# Michał Górny <mgorny@gentoo.org>
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
	7)
		;;
	*)
		die "Unsupported EAPI=${EAPI} for ${ECLASS}"
		;;
esac


# == internal control bits ==

# @ECLASS-VARIABLE: _LLVM_MASTER_MAJOR
# @INTERNAL
# @DESCRIPTION:
# The major version of current LLVM trunk.  Used to determine
# the correct branch to use.
_LLVM_MASTER_MAJOR=10

# @ECLASS-VARIABLE: _LLVM_SOURCE_TYPE
# @INTERNAL
# @DESCRIPTION:
# Source type to use: 'git' or 'tar'.
if [[ -z ${_LLVM_SOURCE_TYPE+1} ]]; then
	if [[ ${PV} == *.9999 ]]; then
		_LLVM_SOURCE_TYPE=git
	else
		_LLVM_SOURCE_TYPE=tar
	fi
fi

[[ ${_LLVM_SOURCE_TYPE} == git ]] && inherit git-r3

[[ ${PV} == ${_LLVM_MASTER_MAJOR}.* && ${_LLVM_SOURCE_TYPE} == tar ]] &&
	die "${ECLASS}: Release ebuild for master branch?!"


# == control variables ==

# @ECLASS-VARIABLE: LLVM_COMPONENTS
# @REQUIRED
# @DESCRIPTION:
# List of components needed unconditionally.  Specified as bash array
# with paths relative to llvm-project git.  Automatically translated
# for tarball releases.
#
# The first path specified is used to construct default S.

# @ECLASS-VARIABLE: LLVM_TEST_COMPONENTS
# @DEFAULT_UNSET
# @DESCRIPTION:
# List of additional components needed for tests.


# == global scope logic ==

# @FUNCTION: _llvm.org_get_archives
# @USAGE: <components>
# @INTERNAL
# @DESCRIPTION:
# Set 'archives' array to list of unique archive filenames
# for components passed as parameters.
_llvm.org_get_archives() {
	local c
	archives=()

	for c; do
		local cn=${c%%/*}
		case ${cn} in
			clang) cn=cfe;;
		esac

		local a=${cn}-${PV}.src.tar.xz
		has "${a}" "${archives[@]}" || archives+=( "${a}" )
	done
}

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

	if [[ ${_LLVM_SOURCE_TYPE} == git ]]; then
		EGIT_REPO_URI="https://github.com/llvm/llvm-project.git"

		[[ ${PV} != ${_LLVM_MASTER_MAJOR}.* ]] &&
			EGIT_BRANCH="release/${PV%%.*}.x"
	elif [[ ${_LLVM_SOURCE_TYPE} == tar ]]; then
		if ver_test -ge 9.0.1_rc1; then
			# 9.0.1 RCs as GitHub archive
			SRC_URI+="
				https://github.com/llvm/llvm-project/archive/llvmorg-${PV/_/-}.tar.gz"
		else
			local a archives=()
			_llvm.org_get_archives "${LLVM_COMPONENTS[@]}"
			for a in "${archives[@]}"; do
				SRC_URI+="
					https://releases.llvm.org/${PV}/${a}"
			done
		fi
	else
		die "Invalid _LLVM_SOURCE_TYPE: ${LLVM_SOURCE_TYPE}"
	fi

	S=${WORKDIR}/${LLVM_COMPONENTS[0]}

	if [[ -n ${LLVM_TEST_COMPONENTS+1} ]]; then
		IUSE+=" test"
		RESTRICT+=" !test? ( test )"

		if [[ ${_LLVM_SOURCE_TYPE} == tar ]]; then
			if ver_test -ge 9.0.1_rc1; then
				# everything already fetched
				:
			else
				# split 9.0.0 release and older
				SRC_URI+="
					test? ("

				_llvm.org_get_archives "${LLVM_TEST_COMPONENTS[@]}"
				for a in "${archives[@]}"; do
					SRC_URI+="
						https://releases.llvm.org/${PV}/${a}"
				done

				SRC_URI+="
					)"
			fi
		fi
	fi

	_LLVM_ORG_SET_GLOBALS_CALLED=1
}


# == phase functions ==

EXPORT_FUNCTIONS src_unpack

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

	if [[ ${_LLVM_SOURCE_TYPE} == git ]]; then
		git-r3_fetch
		git-r3_checkout '' . '' "${components[@]}"
	else
		if ver_test -ge 9.0.1_rc1; then
			local archive=llvmorg-${PV/_/-}.tar.gz
			ebegin "Unpacking from ${archive}"
			tar -x -z -o --strip-components 1 \
				-f "${DISTDIR}/${archive}" \
				"${components[@]/#/llvm-project-${archive%.tar*}/}" || die
			eend ${?}
		else
			local c archives
			# TODO: optimize this
			for c in "${components[@]}"; do
				local top_dir=${c%%/*}
				_llvm.org_get_archives "${c}"
				local sub_path=${archives[0]%.tar.xz}
				[[ ${c} == */* ]] && sub_path+=/${c#*/}

				ebegin "Unpacking ${sub_path} from ${archives[0]}"
				mkdir -p "${top_dir}" || die
				tar -C "${top_dir}" -x -J -o --strip-components 1 \
					-f "${DISTDIR}/${archives[0]}" "${sub_path}" || die
				eend ${?}
			done
		fi
	fi
}
