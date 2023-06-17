# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_SETUPTOOLS=bdepend
PYPI_NO_NORMALIZE=1

inherit distutils-r1

DESCRIPTION="Model-driven deployment, config management, and command execution framework"
HOMEPAGE="https://www.ansible.com/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ansible/ansible.git"
	EGIT_BRANCH="devel"
else
	inherit pypi
	KEYWORDS="amd64 ~arm arm64 ~ppc64 ~riscv x86 ~x64-macos"
fi

LICENSE="GPL-3"
SLOT="0"
RESTRICT="test"

RDEPEND="
	dev-python/paramiko[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/httplib2[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/netaddr[${PYTHON_USEDEP}]
	dev-python/pexpect[${PYTHON_USEDEP}]
	>=dev-python/resolvelib-0.5.3[${PYTHON_USEDEP}]
	<dev-python/resolvelib-1.1.0[${PYTHON_USEDEP}]
	net-misc/sshpass
	virtual/ssh
"
BDEPEND="
	>=dev-python/packaging-16.6[${PYTHON_USEDEP}]
	test? (
		dev-python/botocore[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

python_compile() {
	export ANSIBLE_SKIP_CONFLICT_CHECK=1
	distutils-r1_python_compile
}
