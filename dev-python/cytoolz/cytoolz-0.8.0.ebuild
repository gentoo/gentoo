# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1

DESCRIPTION="Cython implementation of Toolz: High performance functional utilities"
HOMEPAGE="https://pypi.python.org/pypi/cytoolz"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

# Informed by author the dep in toolz is not only required but the
# tests are version sensitive.
# https://github.com/pytoolz/cytoolz/issues/57
RDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( dev-python/nose[${PYTHON_USEDEP}]
		>=dev-python/toolz-0.8[${PYTHON_USEDEP}] )"

python_compile() {
	python_is_python3 || local -x CFLAGS="${CFLAGS} -fno-strict-aliasing"

	distutils-r1_python_compile
}

python_test() {
	pushd "${BUILD_DIR}"/lib/ > /dev/null
	PYTHONPATH=.:${PN} nosetests --with-doctest ${PN} || die "tests failed under ${EPYTHON}"
	popd > /dev/null
}
