# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="OpenGL PNG image library"
HOMEPAGE="https://repo.or.cz/w/glpng.git"
SRC_URI="https://repo.or.cz/w/glpng.git/snapshot/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-v${PV}-2266ea1"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="
	media-libs/libpng:0=
	virtual/opengl
"
DEPEND="
	${RDEPEND}
"
