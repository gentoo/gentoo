# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1 pypi

DESCRIPTION="Write unit tests in Python to test actual state of your servers"
HOMEPAGE="
	https://github.com/pytest-dev/pytest-testinfra/
	https://pypi.org/project/pytest-testinfra/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~riscv"

RDEPEND="
	dev-python/pytest[${PYTHON_USEDEP}]
"
# Ansible is called via its CLI
# which(1) is used as fallback when `command -v ...` returns 127
# (which e.g. happens when dash is used as /bin/sh)
# https://github.com/pytest-dev/pytest-testinfra/issues/668
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		app-admin/ansible
		$(python_gen_cond_dep '
			app-admin/salt[${PYTHON_USEDEP}]
		' python3_10)
		dev-python/paramiko[${PYTHON_USEDEP}]
		dev-python/pywinrm[${PYTHON_USEDEP}]
		sys-apps/which
	)
"

distutils_enable_tests pytest

python_test() {
	local -x EPYTEST_DESELECT=()

	# This is the only test which actually fails if salt cannot be imported
	if [[ ${EPYTHON} == python3.11 ]]; then
		EPYTEST_DESELECT+=(
			test/test_backends.py::test_backend_importables
		)
	fi

	epytest
}

pkg_postinst() {
	elog "For the list of available connection back-ends and their dependencies,"
	elog "please consult https://testinfra.readthedocs.io/en/latest/backends.html"
}
