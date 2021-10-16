# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: tree-sitter-grammar.eclass
# @MAINTAINER:
# Matthew Smith <matt@offtopica.uk>
# Nick Sarnie <sarnex@gentoo.org>
# @AUTHOR:
# Matthew Smith <matt@offtopica.uk>
# @SUPPORTED_EAPIS: 8
# @BLURB: Common functions and variables for Tree Sitter grammars

if [[ -z ${_TREE_SITTER_GRAMMAR_ECLASS} ]]; then
_TREE_SITTER_GRAMMAR_ECLASS=1

case ${EAPI} in
	8) ;;
	*) die "EAPI=${EAPI:-0} is not supported" ;;
esac

inherit multilib toolchain-funcs

SRC_URI="https://github.com/tree-sitter/${PN}/archive/${TS_PV:-v${PV}}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${TS_PV:-${PV}}/src

# Needed for tree_sitter/parser.h
DEPEND="dev-libs/tree-sitter"

EXPORT_FUNCTIONS src_compile src_install

# @ECLASS-VARIABLE: TS_PV
# @PRE_INHERIT
# @DEFAULT_UNSET
# @DESCRIPTION:
# Used to override upstream tag name if tagged differently, e.g. most releases
# are v${PV} but some are tagged as rust-${PV}.

# @FUNCTION: _get_tsg_abi_ver
# @INTERNAL
# @DESCRIPTION:
# This internal function determines the ABI version of a grammar library based
# on the package version.
_get_tsg_abi_ver() {
	if ver_test -gt 0.21; then
		die "Grammar too new; unknown ABI version"
	elif ver_test -ge 0.19.0; then
		echo 13
	else
		die "Grammar too old; unknown ABI version"
	fi
}

# @FUNCTION: tree-sitter-grammar_src_compile
# @DESCRIPTION:
# Compiles the Tree Sitter parser as a shared library.
tree-sitter-grammar_src_compile() {
	debug-print-function ${FUNCNAME} "${@}"

	# Grammars always contain parser.c, and sometimes a scanner.c,
	# or scanner.cc.

	tc-export CC CXX
	export CFLAGS="${CFLAGS} -fPIC"
	export CXXFLAGS="${CXXFLAGS} -fPIC"

	local objects=( parser.o )
	if [[ -f "${S}"/scanner.c || -f "${S}"/scanner.cc ]]; then
		objects+=( scanner.o )
	fi
	emake "${objects[@]}"

	local link="$(tc-getCC) ${CFLAGS}"
	if [[ -f "${S}/scanner.cc" ]]; then
		link="$(tc-getCXX) ${CXXFLAGS}"
	fi

	local soname=lib${PN}$(get_libname $(_get_tsg_abi_ver))
	${link} ${LDFLAGS} \
			-shared \
			*.o \
			-Wl,-soname ${soname} \
			-o "${WORKDIR}"/${soname} || die
}

# @FUNCTION: tree-sitter-grammar_src_install
# @DESCRIPTION:
# Installs the Tree Sitter parser library.
tree-sitter-grammar_src_install() {
	debug-print-function ${FUNCNAME} "${@}"

	dolib.so "${WORKDIR}"/lib${PN}$(get_libname $(_get_tsg_abi_ver))
	dosym lib${PN}$(get_libname $(_get_tsg_abi_ver)) \
		  /usr/$(get_libdir)/lib${PN}$(get_libname)
}
fi
