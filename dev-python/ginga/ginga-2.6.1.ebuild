# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_5} )
PYTHON_REQ_USE='tk?'

inherit distutils-r1 eutils fdo-mime

DESCRIPTION="Astronomical image toolkit for Python"
HOMEPAGE="https://ejeschke.github.io/ginga"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

LICENSE="BSD"
SLOT="0"
IUSE="doc examples gtk qt4 qt5 test tk"

RDEPEND="
	dev-python/astropy[${PYTHON_USEDEP}]
	media-fonts/roboto
	gtk? (  dev-python/pygobject[${PYTHON_USEDEP},cairo] )
	qt4? ( || (
		  dev-python/pyside[${PYTHON_USEDEP},help,X]
		  dev-python/PyQt4[${PYTHON_USEDEP},help,X]
	   ) )
	qt5? (  dev-python/PyQt5[${PYTHON_USEDEP},help,gui,widgets] )"

DEPEND="${RDEPEND}
	dev-python/astropy-helpers[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"

PATCHES=( "${FILESDIR}"/${PN}-no-roboto.patch )

python_prepare_all() {
	# use system astropy-helpers instead of bundled one
	sed -i -e '/auto_use/s/True/False/' setup.cfg || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		python_setup
		PYTHONPATH="${BUILD_DIR}"/lib esetup.py build_sphinx --no-intersphinx
	fi
}

python_test() {
	esetup.py test
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/_build/html/. )
	distutils-r1_python_install_all
	rm -r "${ED%/}"/usr/lib*/*/*/ginga/examples || die
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r ginga/examples
	fi
	domenu ginga.desktop
}

pkg_postinst() {
	optfeature "Pick, Cuts, Histogram, LineProfile" \
			   dev-python/matplotlib sci-libs/scipy
	optfeature "Online help browser" dev-qt/qtwebkit
	optfeature "To save a movie" media-video/mplayer
	optfeature "Speeds up rotation and some transformations" \
			   dev-python/numexpr dev-python/opencv dev-python/pyopencl
	optfeature "Aids in identifying files when opening them" \
			   dev-python/filemagic
	optfeature "Useful for various RGB file manipulations" dev-python/pillow

	# Update mimedb for the new .desktop file
	fdo-mime_desktop_database_update
}
