# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils user

DESCRIPTION="Abstract Shooting Game"
HOMEPAGE="http://www.asahi-net.or.jp/~cs8k-cyu/windows/noiz2sa_e.html https://sourceforge.net/projects/noiz2sa/"
SRC_URI="mirror://sourceforge/noiz2sa/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="
	>=dev-libs/libbulletml-0.0.3
	media-libs/sdl-mixer[vorbis]
	virtual/opengl"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}/src

PATCHES=(
	"${FILESDIR}"/${P}-gcc41.patch
	"${FILESDIR}"/${P}-underlink.patch
)

src_prepare(){
	default
	cp makefile.lin Makefile || die
}

src_install(){
	local datadir="/usr/share/games/${PN}"

	dobin ${PN}
	dodir "${datadir}"
	dodoc ../readme*

	cp -r ../noiz2sa_share/* "${D}/${datadir}" || die
}
