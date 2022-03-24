# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Losslessly convert raster images to PDF"
HOMEPAGE="https://gitlab.mister-muffin.de/josch/img2pdf"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gui"

# pytest-xdist isn't really required but it helps speed up tests
BDEPEND="
	test? (
		app-text/ghostscript-gpl
		app-text/mupdf
		app-text/poppler[cairo,png,tiff]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pdfrw[${PYTHON_USEDEP}]
		dev-python/pillow[tiff,${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
		media-gfx/imagemagick[jpeg,jpeg2k,lcms,png,-q8,-q32,tiff]
		media-libs/exiftool
		media-libs/netpbm[jpeg]
	)
"
RDEPEND="
	dev-python/pikepdf[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	gui? ( $(python_gen_impl_dep tk) )
"

# gif animation test fails
PATCHES=( "${FILESDIR}"/${P}-test-gif-animation.patch )

distutils_enable_tests pytest

src_prepare() {
	distutils-r1_python_prepare_all

	# Remove gui executable if there's no demand/support for it.
	if ! use gui; then
		sed -i '/gui_scripts/d' setup.py || die
	fi

	# gif animation test fails
	rm src/tests/input/animation.gif src/tests/output/animation.gif.pdf || die "rm animation gif failes"
}

python_test() {
	epytest -n auto
}
