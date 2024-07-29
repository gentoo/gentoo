# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYPI_NO_NORMALIZE=1
PYPI_PN=${PN/-/.}
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="A wrapper for the GitHub API written in python"
HOMEPAGE="
	https://github.com/sigmavirus24/github3.py/
	https://pypi.org/project/github3.py/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-vcs/git
	>=dev-python/pyjwt-2.3.0[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.6.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.18[${PYTHON_USEDEP}]
	>=dev-python/uritemplate-3.0.0[${PYTHON_USEDEP}]
"
# via PyJWT[crypto]
RDEPEND+="
	>=dev-python/cryptography-3.3.1[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/betamax-0.8.0[${PYTHON_USEDEP}]
		>=dev-python/betamax-matchers-0.3.0[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# betamax / urllib3 problem
		# upstream marked these tests xfail...
		# https://github.com/sigmavirus24/github3.py/commit/9d6124c09b0997b5e83579549bcf22b3e901d7e5
		tests/integration/test_repos_repo.py::TestRepoCommit::test_{diff,patch}
		tests/integration/test_repos_repo.py::TestComparison::test_{diff,patch}
	)

	epytest -o addopts=
}
