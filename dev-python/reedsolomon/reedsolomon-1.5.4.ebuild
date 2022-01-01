# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )
inherit distutils-r1

DESCRIPTION="Pure-Python Reed Solomon encoder/decoder"
HOMEPAGE="https://github.com/tomerfiliba/reedsolomon https://pypi.org/project/reedsolo/"
SRC_URI="https://github.com/tomerfiliba/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
"

python_test() {
	${EPYTHON} tests/test_creedsolo.py || die "creedsolo test failed with ${EPYTHON}"
	${EPYTHON} tests/test_reedsolo.py || die "reedsolo test failed with ${EPYTHON}"
}
