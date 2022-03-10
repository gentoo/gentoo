# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Write unit tests in Python to test actual state of your servers"
HOMEPAGE="https://github.com/pytest-dev/pytest-testinfra"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-python/pytest[${PYTHON_USEDEP}]"
# Ansible is called via its CLI
BDEPEND="dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		<app-admin/ansible-5
		dev-python/paramiko[${PYTHON_USEDEP}]
		dev-python/pywinrm[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '
			app-admin/salt[${PYTHON_USEDEP}]
		' python3_{8..9} )
	)"

distutils_enable_tests pytest

python_test() {
	if [[ ${EPYTHON} == "python3.10" ]]; then
		ewarn "Some of the tests are skipped on ${EPYTHON} because it still isn't supported by app-admin/salt"
		local EPYTEST_DESELECT=(
			test/test_backends.py::test_backend_importables
		)
	fi
	epytest
}

pkg_postinst() {
	elog "For the list of available connection back-ends and their dependencies,"
	elog "please consult https://testinfra.readthedocs.io/en/latest/backends.html"
}
