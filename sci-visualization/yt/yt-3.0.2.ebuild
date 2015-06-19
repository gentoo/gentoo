# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-visualization/yt/yt-3.0.2.ebuild,v 1.1 2014/10/03 21:17:21 xarthisius Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 flag-o-matic

DESCRIPTION="Astrophysical Simulation Analysis and Vizualization package"
HOMEPAGE="http://yt-project.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

CDEPEND="media-libs/freetype:2
	media-libs/libpng:0=
	sci-libs/hdf5:="
RDEPEND="${CDEPEND}
	dev-python/ipython[notebook,${PYTHON_USEDEP}]
	dev-python/pyx[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/h5py[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/sympy[${PYTHON_USEDEP}]"
DEPEND="${CDEPEND}
	>=dev-python/cython-0.19[${PYTHON_USEDEP}]
	>=dev-python/setuptools-0.7[${PYTHON_USEDEP}]
	test? ( ${RDEPEND}
		dev-python/nose[${PYTHON_USEDEP}]
	)"

python_prepare_all() {
	append-flags -fno-strict-aliasing
	sed -i yt/utilities/setup.py \
		-e "s:/usr:${EPREFIX}/usr:g" || die
	distutils-r1_python_prepare_all
}

python_test() {
	pushd "${BUILD_DIR}"/lib > /dev/null
	nosetests -sv || die "Tests fail with ${EPYTHON} ${PWD}"
	popd > /dev/null
}
