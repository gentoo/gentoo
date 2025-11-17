# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=standalone
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Python bindings for libssh client specific to Ansible use case"
HOMEPAGE="
	https://github.com/ansible/pylibssh/
	https://pypi.org/project/ansible-pylibssh/
"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"
# keywords needed for ansible
# ~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86 ~x64-macos

RDEPEND="
	>=net-libs/libssh-0.9.0:=
"
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/expandvars[${PYTHON_USEDEP}]
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		virtual/ssh
	)
"

EPYTEST_PLUGINS=()
# tests have tendency to hang if something goes wrong
: ${EPYTEST_TIMEOUT:=30}
EPYTEST_XDIST=1
distutils_enable_tests pytest

python_test() {
	# Tests require an account that you can login to.
	# They would work by spawning sshd with PermitEmptyPasswords and then ssh'in in with the current user.
	# "portage" and every other portage installable user is nologin.
	# Adding a user that allows logging in does not seem reasonable.
	EPYTEST_IGNORE=(
		tests/unit/scp_test.py
		tests/unit/sftp_test.py
		tests/unit/channel_test.py
	)
	EPYTEST_DESELECT=(
		tests/integration/sshd_test.py::test_sshd_addr_fixture_port
	)
	# pytest.ini adds alls sorts of stuff like pytest-cov
	epytest -o addopts=
}
