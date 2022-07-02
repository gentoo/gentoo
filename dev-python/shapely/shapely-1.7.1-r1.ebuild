# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Geometric objects, predicates, and operations"
HOMEPAGE="https://pypi.org/project/Shapely/ https://github.com/Toblerity/Shapely"
SRC_URI="https://github.com/Toblerity/Shapely/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P^}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"

DEPEND=">=sci-libs/geos-3.9"
RDEPEND="${DEPEND}
	dev-python/numpy[${PYTHON_USEDEP}]
"
BDEPEND="${DEPEND}
	dev-python/cython[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}/${P}-tests-support-geos-3.9.patch"
)

distutils_enable_tests --install pytest
distutils_enable_sphinx docs dev-python/matplotlib
