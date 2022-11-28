# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="subprocess.run replacement with tee(1)-like output"
HOMEPAGE="
	https://github.com/pycontribs/subprocess-tee/
	https://pypi.org/project/subprocess-tee/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv"
IUSE="test-full"
REQUIRED_USE="test-full? ( test )"

# ansible-molecule is invoked as an executable so no need for PYTHON_USEDEP
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	dev-python/setuptools_scm_git_archive[${PYTHON_USEDEP}]
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
