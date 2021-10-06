# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="subprocess.run replacement with tee(1)-like output"
HOMEPAGE="https://github.com/pycontribs/subprocess-tee"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test-full"

REQUIRED_USE="test-full? ( test )"

# ansible-molecule is invoked as an executable so no need for PYTHON_USEDEP
BDEPEND="dev-python/setuptools_scm[${PYTHON_USEDEP}]
	dev-python/setuptools_scm_git_archive[${PYTHON_USEDEP}]
	test? (
		$(python_gen_cond_dep '
			dev-python/enrich[${PYTHON_USEDEP}]
		' python3_{8,9})
		test-full? ( app-admin/ansible-molecule )
	)"

distutils_enable_tests pytest

# dev-python/{,en}rich ebuilds do not support python3_10 yet.
# We test fine (modulo some deprecation warnings) against 3.10 under tox, though.
python_test() {
	if [[ ${EPYTHON} == "python3.10" ]]; then
		ewarn "Skipping tests for ${EPYTHON} due to missing dependencies"
		return 0
	fi
	if ! use test-full; then
		local -x EPYTEST_DESELECT=( "src/${PN/-/_}/test/test_func.py::test_molecule" )
	fi
	distutils-r1_python_test
}
