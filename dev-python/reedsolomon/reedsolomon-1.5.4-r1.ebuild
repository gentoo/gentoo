# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Pure-Python Reed Solomon encoder/decoder"
HOMEPAGE="https://github.com/tomerfiliba/reedsolomon https://pypi.org/project/reedsolo/"
SRC_URI="https://github.com/tomerfiliba/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
"

src_prepare() {
	default
	rm creedsolo.c || die
}

python_test() {
	"${EPYTHON}" tests/test_creedsolo.py || die "creedsolo test failed with ${EPYTHON}"
	"${EPYTHON}" tests/test_reedsolo.py || die "reedsolo test failed with ${EPYTHON}"
}
