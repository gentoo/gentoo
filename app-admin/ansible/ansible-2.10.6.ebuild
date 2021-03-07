# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=bdepend

inherit distutils-r1 eutils

DESCRIPTION="Model-driven deployment, config management, and command execution framework"
HOMEPAGE="https://ansible.com/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ansible/ansible.git"
	EGIT_BRANCH="devel"
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86 ~x64-macos"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="test"
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
	net-misc/sshpass
	virtual/ssh
	app-admin/ansible-base
"
DEPEND="
	>=dev-python/packaging-16.6[${PYTHON_USEDEP}]
	app-admin/ansible-base
	test? (
		${RDEPEND}
		dev-python/nose[${PYTHON_USEDEP}]
		>=dev-python/mock-1.0.1[${PYTHON_USEDEP}]
		dev-python/passlib[${PYTHON_USEDEP}]
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-python/unittest2[${PYTHON_USEDEP}]
		dev-vcs/git
	)"

python_compile() {
	export ANSIBLE_SKIP_CONFLICT_CHECK=1
	distutils-r1_python_compile
}

python_test() {
	nosetests -d -w test/units -v --with-coverage --cover-package=ansible --cover-branches || die
}
