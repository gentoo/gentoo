# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4} )

MY_PN=tables
MY_P=${MY_PN}-${PV}

inherit distutils-r1

DESCRIPTION="Hierarchical datasets for Python"
HOMEPAGE="http://www.pytables.org/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="BSD"
IUSE="doc examples"

RDEPEND="
	app-arch/bzip2:0=
	dev-libs/c-blosc:0=[hdf5]
	dev-libs/lzo:2=
	>=dev-python/numpy-1.7.1[${PYTHON_USEDEP}]
	>=dev-python/numexpr-2.4[${PYTHON_USEDEP}]
	>=sci-libs/hdf5-1.8.4:0="
DEPEND="${RDEPEND}
	>=dev-python/cython-0.14[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_P}"

DOCS=( ANNOUNCE.txt RELEASE_NOTES.txt THANKS )

PATCHES=(
	"${FILESDIR}"/${P}-blosc.patch
	)

python_prepare_all() {
	export HDF5_DIR="${EPREFIX}"/usr
	sed \
		-e "s:/usr:${EPREFIX}/usr:g" \
		-e 's:"c-blosc/hdf5/blosc_filter.c"::g' \
		-i setup.py || die
	rm -r c-blosc/{blosc,hdf5,internal-complibs} || die
	distutils-r1_python_prepare_all
}

python_compile() {
	python_is_python3 || local -x CFLAGS="${CFLAGS} -fno-strict-aliasing"
	distutils-r1_python_compile
}

python_test() {
	cd "${BUILD_DIR}"/lib* || die
	${EPYTHON} tables/tests/test_all.py || die
}

python_install_all() {
	if use doc; then
		HTML_DOCS=( doc/html/. )
		DOCS+=( doc/scripts )
	fi
	distutils-r1_python_install_all

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
		doins -r contrib
	fi
}
