# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Transform DocBook using TeX macros"
HOMEPAGE="http://dblatex.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="inkscape"

RDEPEND="
	app-text/docbook-xml-dtd:4.5
	dev-libs/kpathsea
	dev-libs/libxslt
	dev-libs/libxslt
	dev-texlive/texlive-fontutils
	dev-texlive/texlive-latex
	dev-texlive/texlive-latexextra
	dev-texlive/texlive-latexrecommended
	|| ( dev-texlive/texlive-mathscience dev-texlive/texlive-mathextra )
	dev-texlive/texlive-pictures
	dev-texlive/texlive-xetex
	gnome-base/librsvg
	media-gfx/imagemagick
	media-gfx/transfig
	inkscape? ( media-gfx/inkscape )
"
DEPEND="${RDEPEND}"

python_prepare_all() {
	use inkscape || eapply "${FILESDIR}/${P}-no-inkscape-dependency.patch"
	eapply "${FILESDIR}/${PN}-path-logging.patch"
	eapply "${FILESDIR}/${PN}-setup.patch"
	distutils-r1_python_prepare_all
}

python_install() {
	distutils-r1_python_install
	python_doscript "${S}"/scripts/dblatex
}

python_install_all() {
	distutils-r1_python_install_all
	# move package documentation to a folder name containing version number
	mv "${D%/}"/usr/share/doc/${PN} "${D%/}"/usr/share/doc/${PF} || die
}
