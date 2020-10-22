# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{6,7,8,9} )
# The package uses pkg_resources to determine its version
DISTUTILS_USE_SETUPTOOLS=manual

inherit distutils-r1

DESCRIPTION="Database of countries, subdivisions, languages, currencies and script"
HOMEPAGE="https://github.com/flyingcircusio/pycountry"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 arm64 ~ia64 ppc ~sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
"

# https://github.com/flyingcircusio/pycountry/pull/51
PATCHES=( "${FILESDIR}/${P}-fix-tests-for-pypy3.patch" )

python_test() {
	# The package uses pkg_resources to determine its version
	distutils_install_for_testing
	pytest -vv || die "Tests fail with ${EPYTHON}"
}
