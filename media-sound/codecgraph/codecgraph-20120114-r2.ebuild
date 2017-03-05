# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

DESCRIPTION="Generates a graph based on the ALSA description of an HD Audio codec"
HOMEPAGE="http://helllabs.org/codecgraph/"
SRC_URI="http://helllabs.org/codecgraph/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	media-gfx/graphviz"
DEPEND="${RDEPEND}
	media-gfx/imagemagick"

PATCHES=( "${FILESDIR}/${PV}-makefile-prefix.diff" )

src_configure() {
	python_fix_shebang *.py
}

src_install() {
	default
	dodoc codecs.txt IDEAS
}
