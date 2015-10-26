# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

DESCRIPTION="Transform DocBook using TeX macros"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
HOMEPAGE="http://dblatex.sourceforge.net/"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-texlive/texlive-latexextra
	dev-texlive/texlive-latexrecommended
	dev-texlive/texlive-mathextra
	dev-texlive/texlive-xetex
	dev-libs/libxslt
	app-text/docbook-xml-dtd:*
	dev-texlive/texlive-pictures"
RDEPEND="${DEPEND}"

PATCHES=(
	"$FILESDIR/$P-install_layout.patch"
	"$FILESDIR/$P-path-logging.patch"
)

src_install() {
	distutils-r1_src_install || die "distutils install failed"

	python_doscript "${S}"/scripts/dblatex || die "python_doscript failed"
}
