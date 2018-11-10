# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy )

inherit distutils-r1

DESCRIPTION="A drop in replacement for xpyb, an XCB python binding"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
HOMEPAGE="https://github.com/tych0/xcffib"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

COMMON_DEPEND="x11-libs/libxcb"

RDEPEND="
	$(python_gen_cond_dep '>=dev-python/cffi-1.1:=[${PYTHON_USEDEP}]' 'python*')
	$(python_gen_cond_dep '>=virtual/pypy-2.6.0' pypy )
	dev-python/six[${PYTHON_USEDEP}]
	${COMMON_DEPEND}"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	${COMMON_DEPEND}
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

python_test() {
	nosetests -d -v || die
}
