# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Losslessly convert raster images to PDF"
HOMEPAGE="https://gitlab.mister-muffin.de/josch/img2pdf"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gui"

# missing dev-python/pdfrw dependency and
# require old version of imagemagick
# waiting new version
RESTRICT="test"

#BDEPEND="test? (
#	dev-python/numpy[${PYTHON_USEDEP}]
#	dev-python/pdfrw[${PYTHON_USEDEP}]
#	dev-python/pikepdf[${PYTHON_USEDEP}]
#	dev-python/pytest[${PYTHON_USEDEP}]
#	dev-python/scipy[${PYTHON_USEDEP}]
#	<media-gfx/imagemagick-7.0.0[jpeg,jpeg2k,png,q8,q32,tiff]
#)"
RDEPEND="dev-python/pikepdf[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	gui? ( $(python_gen_impl_dep tk) )"

distutils_enable_tests pytest

src_prepare() {
	distutils-r1_python_prepare_all

	# Remove gui executable if there's no demand/support for it.
	if ! use gui; then
		sed -i '/gui_scripts/d' setup.py || die
	fi
}

python_test() {
	epytest src/img2pdf_test.py
}
