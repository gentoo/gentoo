# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python{3_6,3_7} )

inherit distutils-r1

DESCRIPTION="Better dates and times for Python"
HOMEPAGE="https://github.com/crsmithdev/arrow/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/backports-functools-lru-cache[$(python_gen_usedep 'python2*')]"

DEPEND="
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/chai[${PYTHON_USEDEP}]
		dev-python/simplejson[${PYTHON_USEDEP}]
		${RDEPEND}
	)"

python_prepare() {
	sed -i -e "/with-coverage/d" setup.cfg || die
}

python_test() {
	nosetests -v || die
}
