# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Write unit tests in Python to test actual state of your servers"
HOMEPAGE="
	https://github.com/pytest-dev/pytest-testinfra/
	https://pypi.org/project/pytest-testinfra/
"
SRC_URI="mirror://pypi/${P::1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~riscv"

RDEPEND="
	dev-python/pytest[${PYTHON_USEDEP}]
"
# Ansible is called via its CLI
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		app-admin/ansible
		dev-python/paramiko[${PYTHON_USEDEP}]
		dev-python/pywinrm[${PYTHON_USEDEP}]
		app-admin/salt[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

pkg_postinst() {
	elog "For the list of available connection back-ends and their dependencies,"
	elog "please consult https://testinfra.readthedocs.io/en/latest/backends.html"
}
