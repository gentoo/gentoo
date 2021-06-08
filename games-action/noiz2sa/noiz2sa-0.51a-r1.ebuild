# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Abstract Shooting Game"
HOMEPAGE="https://www.asahi-net.or.jp/~cs8k-cyu/windows/noiz2sa_e.html https://sourceforge.net/projects/noiz2sa/"
SRC_URI="mirror://sourceforge/noiz2sa/${P}.tar.gz"
S="${WORKDIR}/${PN}/src"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	>=dev-libs/libbulletml-0.0.3
	media-libs/sdl-mixer[vorbis]
	virtual/opengl"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-gcc41.patch
	"${FILESDIR}"/${P}-underlink.patch
)

src_prepare() {
	default

	cp makefile.lin Makefile || die

	tc-export CC CXX
}

src_install() {
	local datadir="/usr/share/games/${PN}"

	dobin ${PN}
	dodir "${datadir}"
	dodoc ../readme*

	cp -r ../noiz2sa_share/* "${D}/${datadir}" || die
}
