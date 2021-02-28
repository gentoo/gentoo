# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1

DESCRIPTION="Python bindings for simdjson using libpy"
HOMEPAGE="https://github.com/gerrymanoim/libpy_simdjson"
SRC_URI="https://github.com/gerrymanoim/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-cpp/range-v3:=
	dev-libs/simdjson:=
	dev-libs/libpy[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"
BDEPEND="${DEPEND}"

distutils_enable_tests pytest

python_prepare_all() {
	# benchmark tests have extra dependencies
	rm libpy_simdjson/tests/test_benchmark.py || die

	sed -e 's:werror=True:werror=False:' -i setup.py || die

	distutils-r1_python_prepare_all
}
