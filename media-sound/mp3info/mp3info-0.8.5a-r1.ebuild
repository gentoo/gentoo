# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="An MP3 technical info viewer and ID3 1.x tag editor"
HOMEPAGE="https://ibiblio.org/mp3info/"
SRC_URI="https://ibiblio.org/pub/linux/apps/sound/mp3-utils/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~hppa ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris"
IUSE="gtk"

BDEPEND="
	virtual/pkgconfig
"
DEPEND="
	sys-libs/ncurses:0=
	gtk? ( >=x11-libs/gtk+-2.6.10:2 )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-ldflags.patch"
	"${FILESDIR}/${P}-tinfo.patch"
	"${FILESDIR}/${P}-format-security.patch"
	"${FILESDIR}/${P}-musl.patch"
)

src_compile() {
	emake \
		PKG_CONFIG="$(tc-getPKG_CONFIG)" \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		mp3info \
		$(usex gtk gmp3info '')
}

src_install() {
	dobin mp3info $(usex gtk gmp3info '')

	dodoc ChangeLog README
	doman mp3info.1
}
