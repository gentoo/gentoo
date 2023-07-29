# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1

DESCRIPTION="Python interface to the PROJ library"
HOMEPAGE="
	https://github.com/pyproj4/pyproj/
	https://pypi.org/project/pyproj/
"
SRC_URI="
	https://github.com/pyproj4/pyproj/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86 ~amd64-linux"

DEPEND="
	>=sci-libs/proj-9.0.0:=
"
RDEPEND="
	dev-python/certifi[${PYTHON_USEDEP}]
	${DEPEND}
"
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	test? (
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/shapely[${PYTHON_USEDEP}]
		dev-python/xarray[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_configure() {
	# Avoid greedily trying -L/usr/lib, etc
	# https://github.com/pyproj4/pyproj/blob/main/setup.py#L76
	export PROJ_LIBDIR="${ESYSROOT}/usr/$(get_libdir)"
	export PROJ_INCDIR="${ESYSROOT}/usr/include"
}

python_test() {
	rm -rf pyproj || die
	epytest -m "not network" test
}
