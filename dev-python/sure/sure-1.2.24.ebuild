# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy )

inherit distutils-r1

DESCRIPTION="Utility belt for automated testing in python for python"
HOMEPAGE="https://github.com/gabrielfalcao/sure"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

CDEPEND="
	dev-python/mock[${PYTHON_USEDEP}]
	>=dev-python/nose-1.3.0[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	~dev-python/rednose-0.4.1[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${CDEPEND} )
"
RDEPEND="${CDEPEND}"

python_prepare_all() {
	sed \
		-e "82s/read_version()/'${PV}'/" \
		-i setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	nosetests -v -s tests --rednose || die "Tests failed under ${EPYTHON}"
}
