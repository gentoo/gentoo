# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517="setuptools"
DISTUTILS_EXT=1

inherit desktop flag-o-matic xdg distutils-r1

DESCRIPTION="A Python-extensible molecular graphics system"
HOMEPAGE="https://www.pymol.org/"
SRC_URI="https://github.com/schrodinger/pymol-open-source/archive/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}"/${PN}-open-source-${PV}

LICENSE="BitstreamVera BSD freedist HPND OFL-1.0 public-domain UoI-NCSA" #844991
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="+netcdf web"

DEPEND="
	dev-cpp/msgpack-cxx
	dev-libs/mmtf-cpp
	dev-python/numpy[${PYTHON_USEDEP}]
	sys-libs/zlib
	media-libs/freetype:2
	media-libs/glew:0=
	media-libs/glm
	media-libs/libpng:0=
	netcdf? ( sci-libs/netcdf:0= )
"
BDEPEND="test? ( >=dev-cpp/catch-2:0 )"
RDEPEND="
	${DEPEND}
	media-video/mpeg-tools
	dev-python/pyopengl[${PYTHON_USEDEP}]
	dev-python/pyqt5[opengl,${PYTHON_USEDEP}]
	dev-python/pmw[${PYTHON_USEDEP}]
	sci-chemistry/chemical-mime-data
"

distutils_enable_tests pytest

# FIXME: We need to still figure out about how to make all the tests pass
# https://bugs.gentoo.org/932127
RESTRICT="test"

PATCHES=(
	"${FILESDIR}/${P}-distutils-py3.12.patch"
	"${FILESDIR}/${P}-SceneGetDrawFlag-indexing.patch"
	"${FILESDIR}/${P}-eof-maeffplugin.patch"
	"${FILESDIR}/${P}-numpy2.patch"
	"${FILESDIR}/${P}-py3.12-progress.patch"
	"${FILESDIR}/${P}-lto-molfile-plugin.patch"
)

python_prepare_all() {
	sed \
		-e "s:\"/usr:\"${EPREFIX}/usr:g" \
		-e "/ext_comp_args.*+=/s:\[.*\]$:\[\]:g" \
		-i setup.py || die

	sed \
		-e "s:/opt/local:${EPREFIX}/usr:g" \
		-e '/ext_comp_args/s:\[.*\]:[]:g' \
		-i setup.py || die
	sed \
		-e "s:\['msgpackc'\]:\['msgpack'\]:g" \
		-i setup.py || die

	append-cxxflags -std=c++17

	distutils-r1_python_prepare_all
}

python_configure_all() {
	use !netcdf && DISTUTILS_ARGS=( --no-vmd-plugins )
}

python_install() {
	distutils-r1_python_install \
		--pymol-path="${EPREFIX}/usr/share/pymol"

	sed \
		-e '1i#!/usr/bin/env python' \
		"${D}/$(python_get_sitedir)"/pymol/__init__.py > "${T}"/${PN} || die
	python_doscript "${T}"/${PN}
}

python_test() {
	"${EPYTHON}" -m pymol -ckqy testing/testing.py --offline --no-mmlibs --no-undo --run all || die
}

python_install_all() {
	distutils-r1_python_install_all

	# Move data to correct location
	dodir /usr/share/pymol
	mv "${D}/$(python_get_sitedir)"/pymol/pymol_path/* "${ED}/usr/share/pymol" || die

	# These environment variables should not go in the wrapper script, or else
	# it will be impossible to use the PyMOL libraries from Python.
	cat >> "${T}"/20pymol <<- EOF || die
		PYMOL_PATH="${EPREFIX}/usr/share/pymol"
		PYMOL_DATA="${EPREFIX}/usr/share/pymol/data"
		PYMOL_SCRIPTS="${EPREFIX}/usr/share/pymol/scripts"
	EOF

	doenvd "${T}"/20pymol

	newicon "${S}"/data/pymol/icons/icon2.svg ${PN}.svg
	make_desktop_entry "${PN} %u"  PyMol ${PN} \
		"Graphics;Education;Science;Chemistry;" \
		"MimeType=chemical/x-pdb;chemical/pdby;chemical/x-mdl-sdfile;chemical/x-mdl-molfile;chemical/x-mol2;chemical/seq-aa-fasta;chemical/seq-na-fasta;chemical/x-xyz;chemical/x-mdl-sdf;chemical/x-macromodel-input;chemical/x-vmd;"

	if ! use web; then
		rm -rf "${D}/$(python_get_sitedir)/web" || die
	fi

	rm -f "${ED}"/usr/share/${PN}/LICENSE || die
}
