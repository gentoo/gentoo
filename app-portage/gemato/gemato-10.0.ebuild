# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# pyblake2 & pysha3 are broken with pypy*
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )
inherit distutils-r1

DESCRIPTION="Stand-alone Manifest generation & verification tool"
HOMEPAGE="https://github.com/mgorny/gemato"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="+blake2 bzip2 +gpg lzma +portage-postsync sha3 test"

MODULE_RDEPEND="
	blake2? ( $(python_gen_cond_dep 'dev-python/pyblake2[${PYTHON_USEDEP}]' python{2_7,3_4,3_5} pypy{,3}) )
	bzip2? ( $(python_gen_cond_dep 'dev-python/bz2file[${PYTHON_USEDEP}]' python2_7 pypy) )
	gpg? ( app-crypt/gnupg )
	lzma? ( $(python_gen_cond_dep 'dev-python/backports-lzma[${PYTHON_USEDEP}]' python2_7 pypy) )
	sha3? ( $(python_gen_cond_dep 'dev-python/pysha3[${PYTHON_USEDEP}]' python{2_7,3_4,3_5} pypy{,3}) )"

RDEPEND="${MODULE_RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	portage-postsync? ( app-crypt/gentoo-keys )"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${MODULE_RDEPEND} )"

python_test() {
	esetup.py test
}

python_install_all() {
	distutils-r1_python_install_all

	if use portage-postsync; then
		exeinto /etc/portage/repo.postsync.d
		doexe utils/repo.postsync.d/00gemato
	fi
}
