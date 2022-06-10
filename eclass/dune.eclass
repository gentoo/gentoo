# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: dune.eclass
# @MAINTAINER:
# Rafael Kitover <rkitover@gmail.com>
# Mark Wright <gienah@gentoo.org>
# ML <ml@gentoo.org>
# @AUTHOR:
# Rafael Kitover <rkitover@gmail.com>
# @SUPPORTED_EAPIS: 6 7 8
# @BLURB: Provides functions for installing Dune packages.
# @DESCRIPTION:
# Provides dependencies on ``dDne`` and ``OCaml`` and default ``src_compile``,
# ``src_test`` and ``src_install`` for Dune-based packages.

# @ECLASS_VARIABLE: DUNE_PKG_NAME
# @PRE_INHERIT
# @DESCRIPTION:
# Sets the actual Dune package name, if different from Gentoo package name.
# Set before inheriting the eclass.
: ${DUNE_PKG_NAME:=${PN}}

case ${EAPI:-0} in
	6|7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI} not supported" ;;
esac

inherit multiprocessing

# Do not complain about CFLAGS etc since ml projects do not use them.
QA_FLAGS_IGNORED='.*'

EXPORT_FUNCTIONS src_compile src_test src_install

RDEPEND=">=dev-lang/ocaml-4:=[ocamlopt?] dev-ml/dune:="
case ${EAPI:-0} in
	6)
		DEPEND="${RDEPEND} dev-ml/dune"
		;;
	*)
		BDEPEND="dev-ml/dune dev-lang/ocaml"
		DEPEND="${RDEPEND}"
		;;
esac

dune_src_compile() {
	ebegin "Building"
	dune build @install -j $(makeopts_jobs) --profile release
	eend $? || die
}

dune_src_test() {
	ebegin "Testing"
	dune runtest -j $(makeopts_jobs) --profile release
	eend $? || die
}

# @FUNCTION: dune-install
# @USAGE: <list of packages>
# @DESCRIPTION:
# Installs the dune packages given as arguments. For each ``${pkg}`` element in
# that list, ``${pkg}.install`` must be readable from ``${PWD}/_build/default``
#
# Example use:
# @CODE
# dune-install menhir menhirLib menhirSdk
# @CODE
dune-install() {
	local -a pkgs=( "${@}" )

	[[ ${#pkgs[@]} -eq 0 ]] && pkgs=( "${DUNE_PKG_NAME}" )

	local -a myduneopts=(
		--prefix="${ED%/}/usr"
		--libdir="${D%/}$(ocamlc -where)"
		--mandir="${ED%/}/usr/share/man"
	)

	local pkg
	for pkg in "${pkgs[@]}" ; do
		ebegin "Installing ${pkg}"
		dune install ${myduneopts[@]} ${pkg}
		eend $? || die

		# Move docs to the appropriate place.
		if [ -d "${ED%/}/usr/doc/${pkg}" ] ; then
			mkdir -p "${ED%/}/usr/share/doc/${PF}/" || die
			mv "${ED%/}/usr/doc/${pkg}" "${ED%/}/usr/share/doc/${PF}/" || die
			rm -rf "${ED%/}/usr/doc" || die
		fi
	done
}

dune_src_install() {
	dune-install ${1:-${DUNE_PKG_NAME}}
}
