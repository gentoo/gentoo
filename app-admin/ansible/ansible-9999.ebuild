# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils git-r3

DESCRIPTION="Model-driven deployment, config management, and command execution framework"
HOMEPAGE="http://ansible.com/"
# the version here is special because upstream did a 2.0.0 release on accident one time...
EGIT_REPO_URI="git://github.com/ansible/ansible.git"
EGIT_BRANCH="devel"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="keyczar test"

RDEPEND="
	keyczar? ( dev-python/keyczar[${PYTHON_USEDEP}] )
	dev-python/paramiko[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/pycrypto-2.6[${PYTHON_USEDEP}]
	dev-python/httplib2[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	net-misc/sshpass
	virtual/ssh
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/nose[${PYTHON_USEDEP}]
		>=dev-python/mock-1.0.1[${PYTHON_USEDEP}]
		<dev-python/mock-1.1[${PYTHON_USEDEP}]
		dev-python/passlib[${PYTHON_USEDEP}]
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-python/unittest2[${PYTHON_USEDEP}]
		dev-vcs/git
	)"

python_test() {
	nosetests -d -w test/units -v --with-coverage --cover-package=ansible --cover-branches || die
}

python_compile_all() {
	local _man
	for _man in ansible{,-{galaxy,playbook,pull,vault}}; do
		a2x -f manpage docs/man/man1/${_man}.1.asciidoc.in || die "Failed generating man page (${_man})"
	done
}

python_install_all() {
	EXAMPLES=( examples )
	distutils-r1_python_install_all

	doman docs/man/man1/*.1
}
