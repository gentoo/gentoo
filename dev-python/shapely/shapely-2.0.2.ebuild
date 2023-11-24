# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

MY_P=${P/_p/.post}
DESCRIPTION="Geometric objects, predicates, and operations"
HOMEPAGE="
	https://pypi.org/project/shapely/
	https://github.com/shapely/shapely/
"
SRC_URI="
	https://github.com/shapely/shapely/archive/${PV/_p/.post}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm64 ~x86"

DEPEND="
	>=sci-libs/geos-3.9
"
RDEPEND="
	${DEPEND}
	dev-python/numpy[${PYTHON_USEDEP}]
"
BDEPEND="
	${DEPEND}
	>=dev-python/cython-0.29.32[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_test() {
	rm -rf shapely || die
	epytest --pyargs shapely
}
