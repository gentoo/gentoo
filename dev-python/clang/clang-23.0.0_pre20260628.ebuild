# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{11..14} )
inherit distutils-r1 llvm.org

DESCRIPTION="Python bindings for llvm-core/clang"
HOMEPAGE="https://llvm.org/"

LICENSE="Apache-2.0-with-LLVM-exceptions UoI-NCSA"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# The module is opening libclang.so directly, and doing some blasphemy
# on top of it.
DEPEND="
	>=llvm-core/clang-${PV}:*
	!llvm-core/llvm:0[clang(-),python(-)]
	!llvm-core/clang:0[python(-)]
"
RDEPEND="
	${DEPEND}
	${PYTHON_DEPS}
"
BDEPEND="
	${PYTHON_DEPS}
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
	test? (
		llvm-core/clang:${LLVM_MAJOR}
	)
"

LLVM_COMPONENTS=( clang/{bindings/python,include} )
llvm.org_set_globals

distutils_enable_tests unittest

python_test() {
	# tests rely on results from a specific clang version, so override
	# the search path
	local -x CLANG_LIBRARY_PATH=${BROOT}/usr/lib/llvm/${LLVM_MAJOR}/$(get_libdir)
	local -x CLANG_NO_DEFAULT_CONFIG=1
	eunittest
}
