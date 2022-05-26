# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: opam.eclass
# @MAINTAINER:
# Mark Wright <gienah@gentoo.org>
# ML <ml@gentoo.org>
# @AUTHOR:
# Alexis Ballier <aballier@gentoo.org>
# @SUPPORTED_EAPIS: 5 6 7
# @BLURB: Provides functions for installing opam packages.
# @DESCRIPTION:
# Provides dependencies on opam and ocaml, opam-install and a default
# src_install for opam-based packages.

case ${EAPI:-0} in
	5|6|7) ;;
	*) die "${ECLASS}: EAPI ${EAPI} not supported" ;;
esac

# Do not complain about CFLAGS etc since ml projects do not use them.
QA_FLAGS_IGNORED='.*'

# @ECLASS_VARIABLE: OPAM_INSTALLER_DEP
# @PRE_INHERIT
# @DESCRIPTION:
# Override dependency for OPAM_INSTALLER
: ${OPAM_INSTALLER_DEP:="dev-ml/opam-installer"}

RDEPEND=">=dev-lang/ocaml-4:="
case ${EAPI:-0} in
	5|6)
		DEPEND="${RDEPEND} ${OPAM_INSTALLER_DEP}"
		;;
	*)
		BDEPEND="${OPAM_INSTALLER_DEP} dev-lang/ocaml"
		DEPEND="${RDEPEND}"
		;;
esac

# @ECLASS_VARIABLE: OPAM_INSTALLER
# @DESCRIPTION:
# Eclass can use different opam-installer binary than the one provided in by system.
: ${OPAM_INSTALLER:=opam-installer}

# @FUNCTION: opam-install
# @USAGE: <list of packages>
# @DESCRIPTION:
# Installs the opam packages given as arguments. For each "${pkg}" element in
# that list, "${pkg}.install" must be readable from current working directory.
opam-install() {
	local pkg
	for pkg ; do
		${OPAM_INSTALLER} -i \
			--prefix="${ED%/}/usr" \
			--libdir="${D%/}/$(ocamlc -where)" \
			--docdir="${ED%/}/usr/share/doc/${PF}" \
			--mandir="${ED%/}/usr/share/man" \
			"${pkg}.install" || die
	done
}

opam_src_install() {
	local pkg="${1:-${PN}}"
	opam-install "${pkg}"
	# Handle opam putting doc in a subdir
	if [ -d "${ED%/}/usr/share/doc/${PF}/${pkg}" ] ; then
		mv "${ED%/}/usr/share/doc/${PF}/${pkg}/"* "${ED%/}/usr/share/doc/${PF}/" || die
		rmdir "${ED%/}/usr/share/doc/${PF}/${pkg}" || die
	fi
}

EXPORT_FUNCTIONS src_install
