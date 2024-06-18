# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="subprocess.run replacement with tee(1)-like output"
HOMEPAGE="
	https://github.com/pycontribs/subprocess-tee/
	https://pypi.org/project/subprocess-tee/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv"
IUSE="test-full"
REQUIRED_USE="test-full? ( test )"

# ansible-molecule is invoked as an executable so no need for PYTHON_USEDEP
BDEPEND="
	>=dev-python/setuptools-scm-7.0.0[${PYTHON_USEDEP}]
	test? (
		dev-python/enrich[${PYTHON_USEDEP}]
		test-full? ( app-admin/ansible-molecule )
	)
"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=()

	if ! use test-full; then
		EPYTEST_DESELECT+=(
			test/test_func.py::test_molecule
		)
	fi

	epytest
}
