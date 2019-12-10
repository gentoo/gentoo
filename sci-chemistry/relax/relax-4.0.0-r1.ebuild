# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

WX_GTK_VER="3.0"

inherit eutils multiprocessing python-single-r1 scons-utils toolchain-funcs wxwidgets virtualx

DESCRIPTION="Molecular dynamics by NMR data analysis"
HOMEPAGE="http://www.nmr-relax.com/"
SRC_URI="http://download.gna.org/relax/${P}.src.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	dev-python/Numdifftools[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/wxpython:${WX_GTK_VER}[${PYTHON_USEDEP}]
	sci-chemistry/molmol
	sci-chemistry/pymol[${PYTHON_USEDEP}]
	sci-chemistry/vmd
	>=sci-libs/bmrblib-1.0.3[${PYTHON_USEDEP}]
	>=sci-libs/minfx-1.0.11[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	sci-visualization/grace
	sci-visualization/opendx
	x11-libs/wxGTK:${WX_GTK_VER}[X]"
DEPEND="${RDEPEND}
	media-gfx/pngcrush
	test? ( ${RDEPEND} )
	"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	rm -rf minfx bmrblib extern/numdifftools || die
	tc-export CC
	need-wxwidgets unicode
}

src_compile() {
	escons
}

src_test() {
	VIRTUALX_COMMAND="${EPYTHON} ./${PN}.py -x --traceback"
	virtualmake
}

src_install() {
	dodoc README docs/{CHANGES,COMMITTERS,JOBS,relax.pdf}

	python_moduleinto ${PN}
	python_domodule *

	rm ${PN} README || die

	make_wrapper ${PN}-nmr "${EPYTHON} $(python_get_sitedir)/${PN}/${PN}.py $@"
}
