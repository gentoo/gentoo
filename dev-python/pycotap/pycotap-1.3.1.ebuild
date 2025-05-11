# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="A tiny test runner that outputs TAP results to standard output"
HOMEPAGE="
	https://github.com/remko/pycotap/
	https://pypi.org/project/pycotap/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc ppc64 ~riscv x86"

PATCHES=(
	"${FILESDIR}"/pycotap-1.3.1-fix-python3.13-tests.patch
)

distutils_enable_tests unittest

python_prepare_all() {
	distutils-r1_python_prepare_all

	sed -i -e "/data_files =/d" setup.py || die

	# Fixup test output assumptions for unittest
	sed -i -e 's/__main__\.TAPTestRunnerTest/test.TAPTestRunnerTest/' test/test.py || die
}

python_test() {
	eunittest test
}
