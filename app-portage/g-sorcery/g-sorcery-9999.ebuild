# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=(python{2_7,3_5,3_6})

inherit distutils-r1 git-r3

DESCRIPTION="framework for ebuild generators"
HOMEPAGE="https://github.com/jauhien/g-sorcery"
SRC_URI=""
EGIT_BRANCH="master"
EGIT_REPO_URI="git://git.gentoo.org/proj/g-sorcery.git"

LICENSE="GPL-2"
SLOT="0"
IUSE="bson git"

DEPEND="bson? ( dev-python/pymongo[${PYTHON_USEDEP}] )
	git? ( dev-vcs/git )
	sys-apps/portage[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
PDEPEND=">=app-portage/layman-2.2.0[g-sorcery(-),${PYTHON_USEDEP}]"

python_test() {
	PYTHONPATH="." "${PYTHON}" scripts/run_tests.py || die
}

python_install_all() {
	distutils-r1_python_install_all

	doman docs/*.8
	docinto html
	dodoc docs/developer_instructions.html
	diropts -m0777
	dodir /var/lib/${PN}
	keepdir /var/lib/${PN}
}
