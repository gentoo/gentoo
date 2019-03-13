# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils

DESCRIPTION="Transform DocBook using TeX macros"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
HOMEPAGE="http://dblatex.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE=""

RDEPEND="
	app-text/texlive
	dev-texlive/texlive-latexextra
	dev-texlive/texlive-latexrecommended
	dev-texlive/texlive-mathscience
	dev-texlive/texlive-pictures
	dev-texlive/texlive-xetex
	dev-libs/libxslt
	app-text/docbook-xml-dtd:4.5
	gnome-base/librsvg
"
DEPEND="${RDEPEND}"

python_prepare_all() {
	distutils-r1_python_prepare_all
	epatch "${FILESDIR}/${P}-no-inkscape-dependency.patch"
	epatch "${FILESDIR}/${PN}-path-logging.patch"
	epatch "${FILESDIR}/${PN}-setup.patch"
}

python_install_all() {
	python_doscript "${S}"/scripts/dblatex
	python_optimize
	distutils-r1_python_install_all
	# move package documentation to a folder name containing version number
	mv "${D}"/usr/share/doc/${PN} "${D}"/usr/share/doc/${PF} || die "mv doc"
}
