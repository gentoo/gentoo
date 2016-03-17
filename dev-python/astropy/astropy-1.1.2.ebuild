# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} )

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
	>=sci-astronomy/wcslib-5:0=
	sci-libs/cfitsio:0=
	sys-libs/zlib:0="
DEPEND="${RDEPEND}
	>=dev-python/astropy-helpers-1.1[${PYTHON_USEDEP}]
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	virtual/pkgconfig
	doc? (
		media-gfx/graphviz
		$(python_gen_cond_dep 'dev-libs/libxml2[${PYTHON_USEDEP}]' python2_7)
		$(python_gen_cond_dep 'dev-python/h5py[${PYTHON_USEDEP}]' python2_7)
		$(python_gen_cond_dep 'dev-python/matplotlib[${PYTHON_USEDEP}]' python2_7)
		$(python_gen_cond_dep 'dev-python/pytest[${PYTHON_USEDEP}]' python2_7)
		$(python_gen_cond_dep 'dev-python/sphinx[${PYTHON_USEDEP}]' python2_7)
		$(python_gen_cond_dep 'dev-python/wcsaxes[${PYTHON_USEDEP}]' python2_7)
		$(python_gen_cond_dep 'sci-libs/scipy[${PYTHON_USEDEP}]'python2_7)
	)
	test? (
		dev-libs/libxml2[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/h5py[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
		sci-libs/scipy[${PYTHON_USEDEP}]
	)"

REQUIRED_USE="doc? ( || ( $(python_gen_useflags 'python2*') ) )"

PATCHES=(
	"${FILESDIR}/${PN}-1.0.4-system-six.patch"
	"${FILESDIR}/${PN}-1.0.4-system-configobj.patch"
	"${FILESDIR}/${PN}-1.1.1-mark-kown-failures.patch"
	"${FILESDIR}/${PN}-1.1.2-fix-for-pytest-28.patch"
	"${FILESDIR}/${PN}-1.1.2-cfitsio-338.patch"
)

pkg_setup() {
	use doc && DISTUTILS_ALL_SUBPHASE_IMPLS=( 'python2*' )
}

python_prepare_all() {
	export mydistutilsargs="--offline"
	export ASTROPY_USE_SYSTEM_PYTEST=True
	rm -r ${PN}_helpers || die
	cp "${FILESDIR}"/astropy-ply.py astropy/extern/ply.py || die
	rm -r cextern/{expat,erfa,cfitsio,wcslib} || die
	sed -i -e '/auto_use/s/True/False/' setup.cfg || die
	cat >> setup.cfg <<-EOF
	[build]
	use_system_libraries=1
	EOF
	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		python_setup "python2*"
		VARTEXFONTS="${T}"/fonts \
			MPLCONFIGDIR="${BUILD_DIR}" \
			PYTHONPATH="${BUILD_DIR}"/lib \
			esetup.py build_sphinx
	fi
}

python_test() {
	esetup.py test
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
