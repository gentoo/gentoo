# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# backports.lzma is broken with pypy
# pyblake2 & pysha3 are broken with pypy3
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )
inherit distutils-r1

DESCRIPTION="Stand-alone Manifest generation & verification tool"
HOMEPAGE="https://github.com/mgorny/gemato"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="+blake2 bzip2 +gpg lzma sha3"

RDEPEND="
	blake2? ( $(python_gen_cond_dep 'dev-python/pyblake2[${PYTHON_USEDEP}]' python{2_7,3_4,3_5} pypy{,3}) )
	bzip2? ( $(python_gen_cond_dep 'dev-python/bz2file[${PYTHON_USEDEP}]' python2_7 pypy) )
	gpg? ( app-crypt/gnupg )
	lzma? ( $(python_gen_cond_dep 'dev-python/backports-lzma[${PYTHON_USEDEP}]' python2_7 pypy) )
	sha3? ( $(python_gen_cond_dep 'dev-python/pysha3[${PYTHON_USEDEP}]' python{2_7,3_4,3_5} pypy{,3}) )"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	esetup.py test
}
