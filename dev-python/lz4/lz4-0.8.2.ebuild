# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python{2_7,3_6} )

inherit distutils-r1

DESCRIPTION="LZ4 Bindings for Python"
HOMEPAGE="https://pypi.org/project/lz4/ https://github.com/steeve/python-lz4"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="amd64 arm x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=""
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )
"

python_prepare_all() {
	sed \
		-e '/nose/s:setup_requires:test_requires:g' \
		-i setup.py || die
	mkdir "${S}"/tests
	cp "${FILESDIR}"/test.py "${S}"/tests
	distutils-r1_python_prepare_all
}

python_test() {
	esetup.py test || dies "Tests failed with ${EPYTHON}"
}
