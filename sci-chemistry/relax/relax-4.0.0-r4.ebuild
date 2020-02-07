# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

WX_GTK_VER="3.0"

inherit eutils multiprocessing python-single-r1 scons-utils toolchain-funcs wxwidgets virtualx

DESCRIPTION="Molecular dynamics by NMR data analysis"
HOMEPAGE="https://www.nmr-relax.com/"
SRC_URI="http://download.gna.org/relax/${P}.src.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep "
		dev-python/Numdifftools[\${PYTHON_MULTI_USEDEP}]
		|| (
			dev-python/matplotlib-python2[\${PYTHON_MULTI_USEDEP}]
			dev-python/matplotlib[\${PYTHON_MULTI_USEDEP}]
		)
		|| (
			dev-python/numpy-python2[\${PYTHON_MULTI_USEDEP}]
			dev-python/numpy[\${PYTHON_MULTI_USEDEP}]
		)
		dev-python/wxpython:${WX_GTK_VER}[\${PYTHON_MULTI_USEDEP}]
		sci-chemistry/pymol[\${PYTHON_MULTI_USEDEP}]
		>=sci-libs/bmrblib-1.0.3[\${PYTHON_MULTI_USEDEP}]
		>=sci-libs/minfx-1.0.11[\${PYTHON_MULTI_USEDEP}]
		|| (
			sci-libs/scipy-python2[\${PYTHON_MULTI_USEDEP}]
			sci-libs/scipy[\${PYTHON_MULTI_USEDEP}]
		)
	")
	sci-chemistry/molmol
	sci-chemistry/vmd
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
