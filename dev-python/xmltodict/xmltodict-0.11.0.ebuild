# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{2_7,3_5,3_6,3_7} pypy pypy3 )
inherit distutils-r1

DESCRIPTION="Makes working with XML feel like you are working with JSON"
HOMEPAGE="https://github.com/martinblech/xmltodict/ https://pypi.org/project/xmltodict/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

python_test() {
	nosetests || die "Tests fail with ${EPYTHON}"
}
