# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop

DESCRIPTION="Japanese version of chess (commandline + X-Version)"
HOMEPAGE="https://www.gnu.org/software/gnushogi/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X"

RDEPEND="
	sys-libs/ncurses:0=
	X? ( x11-libs/libXaw )"
DEPEND="${RDEPEND}"
BDEPEND="
	>=sys-devel/bison-1.34
	app-alternatives/lex"

PATCHES=(
	"${FILESDIR}"/"${P}-fno-common.patch"
	"${FILESDIR}"/"${P}-makefile.patch"
	"${FILESDIR}"/"${P}-xshogi-parser.patch"
)

src_configure() {
	econf \
		$(use_with X x) \
		$(use_enable X xshogi)
}

src_install() {
	dobin gnushogi/gnushogi
	doman doc/gnushogi.6
	doinfo doc/gnushogi.info

	if use X; then
		dobin xshogi/xshogi
		doman doc/xshogi.6
		make_desktop_entry xshogi XShogi
	fi

	dolib.a gnushogi/gnushogi.bbk
	dodoc README NEWS CONTRIB doc/gnushogi/*.html
}
