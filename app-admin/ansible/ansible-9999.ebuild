# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_5 )

inherit distutils-r1 git-r3

DESCRIPTION="Model-driven deployment, config management, and command execution framework"
HOMEPAGE="https://www.ansible.com/"
EGIT_REPO_URI="git://github.com/ansible/ansible.git"
EGIT_BRANCH="devel"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="test"

RDEPEND="
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/paramiko[${PYTHON_USEDEP}]
	>=dev-python/pycrypto-2.6[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/httplib2[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	app-text/asciidoc
	net-misc/sshpass
	virtual/ssh
"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/packaging-16.6[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/passlib[${PYTHON_USEDEP}]
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-python/unittest2[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-vcs/git
)"

python_prepare_all() {
	rm -fv MANIFEST.in || die
	distutils-r1_python_prepare_all
}

python_test() {
	sed -e "s:pwd_entry.pw_dir:os.environ['HOME']:" \
			-e "s:~%s/local:~%s/${CATEGORY}/${PF}/homedir/local:" \
			-i test/units/test_constants.py || die

	emake tests || die "Tests fail with ${EPYTHON}"
}

python_compile_all() {
	emake -j1 docs
}

python_install_all() {
	distutils-r1_python_install_all

	doman docs/man/man1/${PN}*.1
	dodoc -r examples
}
