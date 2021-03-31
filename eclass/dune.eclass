# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: dune.eclass
# @MAINTAINER:
# rkitover@gmail.com
# Mark Wright <gienah@gentoo.org>
# ML <ml@gentoo.org>
# @AUTHOR:
# Rafael Kitover <rkitover@gmail.com>
# @SUPPORTED_EAPIS: 5 6 7
# @BLURB: Provides functions for installing dune packages.
# @DESCRIPTION:
# Provides dependencies on dune and ocaml and default src_compile, src_test and
# src_install for dune-based packages.

# @ECLASS-VARIABLE: DUNE_PKG_NAME
# @PRE_INHERIT
# @DESCRIPTION:
# Sets the actual dune package name, if different from gentoo package name.
# Set before inheriting the eclass.

case ${EAPI:-0} in
	5|6|7) ;;
	*) die "${ECLASS}: EAPI ${EAPI} not supported" ;;
esac

# Do not complain about CFLAGS etc since ml projects do not use them.
QA_FLAGS_IGNORED='.*'

EXPORT_FUNCTIONS src_compile src_test src_install

RDEPEND=">=dev-lang/ocaml-4:=[ocamlopt?]"
case ${EAPI:-0} in
	0|1|2|3|4|5|6) DEPEND="${RDEPEND} dev-ml/dune";;
	*) BDEPEND="dev-ml/dune dev-lang/ocaml"; DEPEND="${RDEPEND}" ;;
esac

dune_src_compile() {
	dune build @install || die
}

dune_src_test() {
	dune runtest || die
}

# @FUNCTION: dune-install
# @USAGE: <list of packages>
# @DESCRIPTION:
# Installs the dune packages given as arguments. For each "${pkg}" element in
# that list, "${pkg}.install" must be readable from "${PWD}/_build/default"
dune-install() {
	local pkg
	for pkg ; do
		dune install \
			--prefix="${ED%/}/usr" \
			--libdir="${D%/}$(ocamlc -where)" \
			--mandir="${ED%/}/usr/share/man" \
			"${pkg}" || die
	done
}

dune_src_install() {
	local pkg="${1:-${DUNE_PKG_NAME:-${PN}}}"

	dune-install "${pkg}"

	# Move docs to the appropriate place.
	if [ -d "${ED%/}/usr/doc/${pkg}" ] ; then
		mkdir -p "${ED%/}/usr/share/doc/${PF}/" || die
		mv "${ED%/}/usr/doc/${pkg}/"* "${ED%/}/usr/share/doc/${PF}/" || die
		rm -rf "${ED%/}/usr/doc" || die
	fi
}
