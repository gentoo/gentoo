# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop flag-o-matic toolchain-funcs

DESCRIPTION="Multiplayer Gauntlet-style arcade game"
HOMEPAGE="http://xtux.sourceforge.net/"
SRC_URI="mirror://sourceforge/xtux/xtux-src-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="x11-libs/libXpm"
RDEPEND="${DEPEND}
	media-fonts/font-adobe-75dpi"

S="${WORKDIR}/${PN}"

PATCHES=(
	"${FILESDIR}"/${P}-Makefile.patch
	"${FILESDIR}"/${P}-particles.patch
	"${FILESDIR}"/${P}-tux_serv-path.patch
	"${FILESDIR}"/${P}-missing-include.patch
)

src_prepare() {
	default
	find data/ -type d -name .xvpics -exec rm -rf \{\} + || die
}

src_configure() {
	# bug #858605
	filter-lto

	tc-export AR CC RANLIB
}

src_compile() {
	# Not parallel-make friendly (bug #247332)
	emake DATADIR="/usr/share/xtux/data" common
	emake DATADIR="/usr/share/xtux/data" ggz
	emake DATADIR="/usr/share/xtux/data" server
	emake DATADIR="/usr/share/xtux/data" client
}

src_install() {
	dobin xtux tux_serv

	einstalldocs
	dodoc -r doc/.

	insinto /usr/share/xtux
	doins -r data

	newicon data/images/icon.xpm ${PN}.xpm
	make_desktop_entry xtux "Xtux"
}
