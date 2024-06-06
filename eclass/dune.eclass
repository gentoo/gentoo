# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: dune.eclass
# @MAINTAINER:
# rkitover@gmail.com
# Mark Wright <gienah@gentoo.org>
# ML <ml@gentoo.org>
# @AUTHOR:
# Rafael Kitover <rkitover@gmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Provides functions for installing Dune packages.
# @DESCRIPTION:
# Provides dependencies on Dune and OCaml and default src_compile, src_test and
# src_install for Dune-based packages.

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ ! ${_DUNE_ECLASS} ]]; then
_DUNE_ECLASS=1

# @ECLASS_VARIABLE: DUNE_PKG_NAME
# @PRE_INHERIT
# @DESCRIPTION:
# Sets the actual Dune package name, if different from Gentoo package name.
# Set before inheriting the eclass.
: "${DUNE_PKG_NAME:=${PN}}"

inherit edo multiprocessing

# Do not complain about CFLAGS etc since ml projects do not use them.
QA_FLAGS_IGNORED='.*'

RDEPEND="
	>=dev-lang/ocaml-4:=[ocamlopt?]
	dev-ml/dune:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-lang/ocaml
	dev-ml/dune
"

# @FUNCTION: edune
# @USAGE: <arg> ...
# @DESCRIPTION:
# A thin wrapper for the `dune` command.
# Runs `dune` with given arguments and dies on failure.
#
# Example use:
# @CODE
# edune clean
# @CODE
edune() {
	debug-print-function ${FUNCNAME} "${@}"

	edo dune "${@}"
}

# @FUNCTION: dune-release
# @USAGE: <subcommand> [--target target] [package] ...
# @DESCRIPTION:
# Run a selected subcommand for either all of dune packages in current
# directory or only the selected packages. In case of all packages the package
# detection is done via dune itself.
# The `--target` option specifies a target for the selected subcommand,
# it is primarily used for `dune build`, for more info see `man dune-build`.
#
# Example use:
# @CODE
# dune-release build --target @install menhir menhirLib menhirSdk
# @CODE
dune-release() {
	debug-print-function ${FUNCNAME} "${@}"

	local subcommand
	local target

	# Get the subcommand.
	if [[ -z "${1}" ]] ; then
		die "dune-release: missing subcommand"
	else
		subcommand="${1}"
		shift
	fi

	# Detect if the target is specified.
	case "${1}" in
		--target )
			target="${2}"
			shift
			shift
			;;
	esac

	local -a myduneopts=(
		--display=short
		--profile release
		-j $(makeopts_jobs)
	)

	# Resolve the package flag.
	if [[ -n "${1}" ]] ; then
		myduneopts+=( --for-release-of-packages="$(IFS="," ; echo "${*}")" )
	fi

	edune ${subcommand} ${target} "${myduneopts[@]}"
}

# @FUNCTION: dune-compile
# @USAGE: [package] ...
# @DESCRIPTION:
# Builds either all of or selected dune packages in current directory.
#
# Example use:
# @CODE
# dune-compile menhir menhirLib menhirSdk
# @CODE
dune-compile() {
	debug-print-function ${FUNCNAME} "${@}"

	dune-release build --target @install "${@}"
}

# @FUNCTION: dune-test
# @USAGE: [package] ...
# @DESCRIPTION:
# Tests either all of or selected dune packages in current directory.
#
# Example use:
# @CODE
# dune-test menhir menhirLib menhirSdk
# @CODE
dune-test() {
	debug-print-function ${FUNCNAME} "${@}"

	dune-release runtest "${@}"
}

dune_src_compile() {
	dune-compile
}

dune_src_test() {
	dune-test
}

# @FUNCTION: dune-install
# @USAGE: <list of packages>
# @DESCRIPTION:
# Installs the dune packages given as arguments. For each "${pkg}" element in
# that list, "${pkg}.install" must be readable from "${PWD}/_build/default"
#
# Example use:
# @CODE
# dune-install menhir menhirLib menhirSdk
# @CODE
dune-install() {
	debug-print-function ${FUNCNAME} "${@}"

	local -a pkgs=( "${@}" )

	[[ ${#pkgs[@]} -eq 0 ]] && pkgs=( "${DUNE_PKG_NAME}" )

	local -a myduneopts=(
		--prefix="${ED}/usr"
		--libdir="${D}$(ocamlc -where)"
		--mandir="${ED}/usr/share/man"
	)

	local pkg
	for pkg in "${pkgs[@]}" ; do
		edune install ${myduneopts[@]} ${pkg}

		# Move docs to the appropriate place.
		if [[ -d "${ED}/usr/doc/${pkg}" ]] ; then
			mkdir -p "${ED}/usr/share/doc/${PF}/" || die
			mv "${ED}/usr/doc/${pkg}" "${ED}/usr/share/doc/${PF}/" || die
			rm -rf "${ED}/usr/doc" || die
		fi
	done
}

dune_src_install() {
	# OCaml generates textrels on 32-bit arches
	if use arm || use ppc || use x86 ; then
		export QA_TEXTRELS='.*'
	fi
	dune-install ${1:-${DUNE_PKG_NAME}}
}

fi

EXPORT_FUNCTIONS src_compile src_test src_install
