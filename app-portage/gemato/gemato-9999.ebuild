# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_6,3_7,3_8} pypy3 )
PYTHON_REQ_USE='threads(+)'
inherit distutils-r1 git-r3

DESCRIPTION="Stand-alone Manifest generation & verification tool"
HOMEPAGE="https://github.com/mgorny/gemato"
SRC_URI=""
EGIT_REPO_URI="https://github.com/mgorny/gemato.git"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS=""
IUSE="+blake2 bzip2 +gpg lzma sha3 test tools"
RESTRICT="!test? ( test )"

MODULE_RDEPEND="
	blake2? ( $(python_gen_cond_dep 'dev-python/pyblake2[${PYTHON_USEDEP}]' python{2_7,3_5} pypy{,3}) )
	bzip2? ( $(python_gen_cond_dep 'dev-python/bz2file[${PYTHON_USEDEP}]' python2_7 pypy) )
	gpg? ( app-crypt/gnupg )
	lzma? ( $(python_gen_cond_dep 'dev-python/backports-lzma[${PYTHON_USEDEP}]' python2_7 pypy) )
	sha3? ( $(python_gen_cond_dep 'dev-python/pysha3[${PYTHON_USEDEP}]' python{2_7,3_5} pypy) )"

RDEPEND="${MODULE_RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND=">=dev-python/setuptools-34[${PYTHON_USEDEP}]
	test? ( ${MODULE_RDEPEND} )"

python_test() {
	esetup.py test
}

python_install_all() {
	distutils-r1_python_install_all

	if use tools; then
		exeinto /usr/share/gemato
		doexe utils/*.{bash,py}
	fi
}
