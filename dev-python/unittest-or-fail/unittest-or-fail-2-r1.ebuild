# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
# in py3.12+ unittest already fails when no tests are found
# we're adding these impls to PYTHON_COMPAT to clean up upgrade graphs
# but we're not installing anything
PYTHON_USED=( pypy3 python3_{10..11} )
PYTHON_COMPAT=( "${PYTHON_USED[@]}" python3_{12..13} )

inherit distutils-r1

DESCRIPTION="Run unittests or fail if no tests were found"
HOMEPAGE="https://github.com/projg2/unittest-or-fail/"
SRC_URI="
	https://github.com/projg2/unittest-or-fail/archive/v${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

python_compile() {
	if has "${EPYTHON/./_}" "${PYTHON_USED[@]}"; then
		distutils-r1_python_compile
	fi
}

# Warning: do not use distutils_enable_tests to avoid a circular
# dependency on itself!
python_test() {
	if has "${EPYTHON/./_}" "${PYTHON_USED[@]}"; then
		"${EPYTHON}" -m unittest -v test/test_unittest_or_fail.py ||
			die "Tests failed with ${EPYTHON}"
	fi
}

python_install() {
	if has "${EPYTHON/./_}" "${PYTHON_USED[@]}"; then
		distutils-r1_python_install
	fi
}
