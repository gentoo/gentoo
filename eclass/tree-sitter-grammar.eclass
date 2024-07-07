# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: tree-sitter-grammar.eclass
# @MAINTAINER:
# Matthew Smith <matthew@gentoo.org>
# Arthur Zamarin <arthurzam@gentoo.org>
# @AUTHOR:
# Matthew Smith <matthew@gentoo.org>
# @SUPPORTED_EAPIS: 8
# @BLURB: Common functions and variables for Tree Sitter grammars

case ${EAPI} in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_TREE_SITTER_GRAMMAR_ECLASS} ]]; then
_TREE_SITTER_GRAMMAR_ECLASS=1

inherit edo multilib toolchain-funcs

SRC_URI="https://github.com/tree-sitter/${PN}/archive/${TS_PV:-v${PV}}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${TS_PV:-${PV}}

BDEPEND+=" test? ( dev-util/tree-sitter-cli )"
IUSE+=" test"
RESTRICT+=" !test? ( test )"

# @ECLASS_VARIABLE: TS_PV
# @PRE_INHERIT
# @DEFAULT_UNSET
# @DESCRIPTION:
# Used to override upstream tag name if tagged differently, e.g. most releases
# are v${PV} but some are tagged as rust-${PV}.

# @ECLASS_VARIABLE: TS_BINDINGS
# @PRE_INHERIT
# @DEFAULT_UNSET
# @DESCRIPTION:
# Array of bindings language to build. Currently only "python" is supported.

for _BINDING in "${TS_BINDINGS[@]}"; do
	case ${_BINDING} in
		python)
			DISTUTILS_EXT=1
			DISTUTILS_OPTIONAL=1
			DISTUTILS_USE_PEP517=setuptools
			PYTHON_COMPAT=( python3_{10..13} )
			inherit distutils-r1

			IUSE+=" python"
			REQUIRED_USE+=" python? ( ${PYTHON_REQUIRED_USE} )"

			DEPEND+=" python? (
				${PYTHON_DEPS}
			)"
			RDEPEND+=" python? (
				${PYTHON_DEPS}
				>=dev-python/tree-sitter-0.21.0[${PYTHON_USEDEP}]
			)"
			BDEPEND+=" python? (
				${PYTHON_DEPS}
				${DISTUTILS_DEPS}
				dev-python/wheel[${PYTHON_USEDEP}]
			)"
			;;
		*)
			die "Unknown binding: ${_BINDING}"
			;;
	esac
done
unset _BINDING

# @FUNCTION: _get_tsg_abi_ver
# @INTERNAL
# @DESCRIPTION:
# This internal function determines the ABI version of a grammar library based
# on a constant in the source file.
_get_tsg_abi_ver() {
	# This sed script finds ABI definition string in parser source file,
	# substitutes all the string until the ABI number, and prints remains
	# (the ABI number itself)
	sed -n 's/#define LANGUAGE_VERSION //p' "${S}"/src/parser.c ||
		die "Unable to extract ABI version for this grammar"
}

tree-sitter-grammar_src_prepare() {
	debug-print-function ${FUNCNAME} "${@}"

	default

	local binding
	for binding in "${TS_BINDINGS[@]}"; do
		case ${binding} in
			python)
				use python && distutils-r1_src_prepare
				;;
		esac
	done
}

tree-sitter-grammar_src_configure() {
	debug-print-function ${FUNCNAME} "${@}"

	local binding
	for binding in "${TS_BINDINGS[@]}"; do
		case ${binding} in
			python)
				use python && distutils-r1_src_configure
				;;
		esac
	done
}

# @FUNCTION: _tree-sitter-grammar_legacy_compile
# @INTERNAL
# @DESCRIPTION:
# Compiles the Tree Sitter parser as a shared library, the legacy way.
_tree-sitter-grammar_legacy_compile() {
	cd "${S}/src" || die

	# Grammars always contain parser.c, and sometimes a scanner.c,
	# or scanner.cc.

	tc-export CC CXX
	# We want to use the bundled parser.h, not anything lurking on the system, hence -I
	# See https://github.com/tree-sitter/tree-sitter-bash/issues/199#issuecomment-1694416505
	local -x CFLAGS="${CFLAGS} -fPIC -I. -Itree_sitter"
	local -x CXXFLAGS="${CXXFLAGS} -fPIC -I. -Itree_sitter"

	local objects=( parser.o )
	if [[ -f "${S}"/src/scanner.c || -f "${S}"/src/scanner.cc ]]; then
		objects+=( scanner.o )
	fi
	emake "${objects[@]}"

	local link="$(tc-getCC) ${CFLAGS}"
	if [[ -f "${S}/src/scanner.cc" ]]; then
		link="$(tc-getCXX) ${CXXFLAGS}"
	fi

	local soname=lib${PN}$(get_libname $(_get_tsg_abi_ver))

	local soname_args="-Wl,--soname=${soname}"
	if [[ ${CHOST} == *darwin* ]] ; then
		soname_args="-Wl,-install_name,${EPREFIX}/usr/$(get_libdir)/${soname}"
	fi

	edo ${link} ${LDFLAGS} \
			-shared \
			*.o \
			"${soname_args}" \
			-o "${WORKDIR}"/${soname}
}

tree-sitter-grammar_src_compile() {
	debug-print-function ${FUNCNAME} "${@}"

	# legacy grammars don't have a pyproject.toml
	if [[ -f "${S}/pyproject.toml" ]]; then
		sed -e "/SONAME_MINOR :=/s/:=.*$/:= $(_get_tsg_abi_ver)/" -i "${S}/Makefile" || die
		emake \
			CC="$(tc-getCC)" \
			AR="$(tc-getAR)" \
			STRIP="" \
			PREFIX="${EPREFIX}/usr" \
			LIBDIR="${EPREFIX}/usr/$(get_libdir)"
	else
		_tree-sitter-grammar_legacy_compile
	fi

	local binding
	for binding in "${TS_BINDINGS[@]}"; do
		case ${binding} in
			python)
				use python && distutils-r1_src_compile
				;;
		esac
	done
}

# @FUNCTION: tree-sitter-grammar_src_test
# @DESCRIPTION:
# Runs the Tree Sitter parser's test suite.
# See: https://tree-sitter.github.io/tree-sitter/creating-parsers#command-test
tree-sitter-grammar_src_test() {
	debug-print-function ${FUNCNAME} "${@}"

	tree-sitter test || die "Test suite failed"
}

tree-sitter-grammar_src_install() {
	debug-print-function ${FUNCNAME} "${@}"

	# legacy grammars don't have a pyproject.toml
	if [[ -f "${S}/pyproject.toml" ]]; then
		emake \
			PREFIX="${EPREFIX}/usr" \
			LIBDIR="${EPREFIX}/usr/$(get_libdir)" \
			DESTDIR="${D}/" \
			install
		find "${D}" -name '*.a' -delete || die "failed to remove static libraries"
	else
		local soname=lib${PN}$(get_libname $(_get_tsg_abi_ver))

		dolib.so "${WORKDIR}/${soname}"
		dosym "${soname}" /usr/$(get_libdir)/lib${PN}$(get_libname)
	fi

	local binding
	for binding in "${TS_BINDINGS[@]}"; do
		case ${binding} in
			python)
				use python && distutils-r1_src_install
				;;
		esac
	done
}

fi

EXPORT_FUNCTIONS src_prepare src_configure src_compile src_test src_install
