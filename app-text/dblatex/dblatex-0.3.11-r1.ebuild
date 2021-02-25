# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1

DESCRIPTION="Transform DocBook using TeX macros"
HOMEPAGE="http://dblatex.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/project/dblatex/dblatex/${P}/${P}py3.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ~hppa ~ia64 ~ppc64 sparc x86"
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
	dev-texlive/texlive-mathscience
	dev-texlive/texlive-pictures
	dev-texlive/texlive-xetex
	gnome-base/librsvg
	media-gfx/imagemagick
	media-gfx/transfig
	inkscape? ( media-gfx/inkscape )
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${P}py3"

PATCHES=(
	 "${FILESDIR}/${P}-path-logging.patch"
	 "${FILESDIR}/${P}-setup.patch"
	 "${FILESDIR}/${P}-encode.patch"
)

python_prepare_all() {
	# Manual page is precomressed, but we will use our own compression later.
	gunzip docs/manpage/dblatex.1.gz || die
	# If we dont have inkscape we need to use an alternative SVG converter
	use inkscape || eapply "${FILESDIR}/${P}-no-inkscape-dependency.patch"
	# If we use inscape however we want to make dblatex compatible with v1.0
	use inkscape && eapply "${FILESDIR}/${P}-inkscape-1.0.patch"
	# We need to fix version information in the docs and some metadata
	grep -l -I -R "0.3.11py3" | xargs -n1 sed -i -e "s/${PV}py3/${PV}/" || die
	distutils-r1_python_prepare_all
}

python_install_all() {
	distutils-r1_python_install_all
	# Move package documentation to a folder name containing version number
	mv "${D}"/usr/share/doc/${PN} "${D}"/usr/share/doc/${PF} || die
}
