# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit distutils-r1

DESCRIPTION="A generator library for concise, unambiguous and URL-safe UUIDs"
HOMEPAGE="https://pypi.org/project/shortuuid"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE="test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
		test? ( dev-python/pep8[${PYTHON_USEDEP}] )"

python_test() {
	${EPYTHON} ${PN}/tests.py || die "Tests failed with ${EPYTHON}"
}
