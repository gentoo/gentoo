# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Python Reed Solomon encoder/decoder"
HOMEPAGE="
	https://github.com/tomerfiliba/reedsolomon/
	https://pypi.org/project/reedsolo/
"
SRC_URI="
	https://github.com/tomerfiliba/reedsolomon/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="|| ( Unlicense MIT-0 )"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
"

src_configure() {
	DISTUTILS_ARGS=( --cythonize )
}

python_test() {
	"${EPYTHON}" tests/test_creedsolo.py || die "creedsolo test failed with ${EPYTHON}"
	"${EPYTHON}" tests/test_reedsolo.py || die "reedsolo test failed with ${EPYTHON}"
}
