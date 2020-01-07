# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_6,3_7} )

inherit distutils-r1

DESCRIPTION="A cached-property for decorating methods in classes"
HOMEPAGE="https://github.com/pydanny/cached-property"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? (
		dev-python/pytest
		dev-python/freezegun
		)"
RDEPEND=""

src_install() {
	distutils-r1_src_install
	dodoc README.rst HISTORY.rst CONTRIBUTING.rst AUTHORS.rst
}

python_test() {
	local ignore=""
	if [[ ${EPYTHON} == python2.7 ]]; then
		ignore="--ignore=tests/test_coroutine_cached_property.py \
			--ignore=tests/test_async_cached_property.py"
	fi
	if [[ ${EPYTHON} == python3.4 ]]; then
		ignore="--ignore=test_async_cached_property.py"
	fi
	py.test -v ${ignore} tests/ || die
}
