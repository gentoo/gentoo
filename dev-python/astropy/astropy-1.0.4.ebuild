# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="Core functionality for performing astrophysics with Python"
HOMEPAGE="http://astropy.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc test"

RDEPEND="
	>=dev-libs/expat-2.1.0:0=
	dev-python/configobj[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/ply[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	>=sci-astronomy/erfa-1.2:0=
	>=sci-astronomy/wcslib-4.25:0=
	>=sci-libs/cfitsio-3.350:0=
	sys-libs/zlib:0="
DEPEND="${RDEPEND}
	dev-python/astropy-helpers[${PYTHON_USEDEP}]
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	virtual/pkgconfig
	doc? (
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
		media-gfx/graphviz
	)
	test? (
		dev-libs/libxml2[${PYTHON_USEDEP}]
		dev-python/h5py[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		sci-libs/scipy[${PYTHON_USEDEP}]
	)"

PATCHES=(
	"${FILESDIR}/${P}-disable_helper.patch"
	"${FILESDIR}/${P}-system-six.patch"
	"${FILESDIR}/${P}-system-pytest.patch"
	"${FILESDIR}/${P}-system-configobj.patch"
	)

python_prepare_all() {
	export mydistutilsargs="--offline"
	rm -r ${PN}_helpers || die
	cp "${FILESDIR}"/astropy-ply.py astropy/extern/ply.py || die
	rm -r cextern/{expat,erfa,cfitsio,wcslib} || die

	echo "[build]" >> setup.cfg
	echo "use_system_libraries=1" >> setup.cfg

	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		python_export_best
		VARTEXFONTS="${T}"/fonts \
			MPLCONFIGDIR="${BUILD_DIR}" \
			PYTHONPATH="${BUILD_DIR}"/lib \
			esetup.py build_sphinx
	fi
}

python_test() {
	py.test -vv -k "not test_web_profile" astropy || die
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
