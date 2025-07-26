# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

DESCRIPTION="Model-driven deployment, config management, and command execution framework"
HOMEPAGE="https://www.ansible.com/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ansible/ansible.git"
	EGIT_BRANCH="devel"
else
	inherit pypi
	KEYWORDS="amd64 ~arm arm64 ~ppc64 ~riscv ~x86 ~x64-macos"
fi

LICENSE="GPL-3"
SLOT="0"

# Upstream runs tests via the ansible-test command, which requires the package
# to be installed prior to testing. Running the test via pytest in non-trivial
# due to the amount of flags that need to be passed.
RESTRICT="test"

RDEPEND="
	>=dev-python/paramiko-3.5.1[${PYTHON_USEDEP}]
	dev-python/jinja2[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/httplib2[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/netaddr[${PYTHON_USEDEP}]
	dev-python/pexpect[${PYTHON_USEDEP}]
	>=dev-python/resolvelib-0.5.3[${PYTHON_USEDEP}]
	<dev-python/resolvelib-2.0.0[${PYTHON_USEDEP}]
	net-misc/sshpass
	virtual/ssh
"

BDEPEND=">=dev-python/packaging-16.6[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}/${P}-resolvelib-upper-bound-2.0.0.patch"
)
