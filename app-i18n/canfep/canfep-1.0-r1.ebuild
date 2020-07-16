# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit toolchain-funcs

DESCRIPTION="Canna Japanese kana-kanji frontend processor on console"
#HOMEPAGE="http://www.geocities.co.jp/SiliconValley-Bay/7584/canfep/"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${P}.tar.gz
	unicode? ( http://hp.vector.co.jp/authors/VA020411/patches/${PN}_utf8.diff )"

LICENSE="canfep"
SLOT="0"
KEYWORDS="~alpha amd64 ~ppc ~sparc x86"
IUSE="unicode"

RDEPEND="app-i18n/canna
	sys-libs/ncurses:="
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-posix-pty.patch
	"${FILESDIR}"/${PN}-termcap.patch
)

src_prepare() {
	use unicode && eapply "${DISTDIR}"/${PN}_utf8.diff
	sed -i 's/$(CFLAGS)/$(CFLAGS) $(LDFLAGS)/' Makefile

	default
}

src_compile() {
	emake \
		CC="$(tc-getCXX)" \
		LIBS="-lcanna $($(tc-getPKG_CONFIG) --libs ncurses)"
}

src_install() {
	dobin ${PN}
	dodoc 00{changes,readme}
}
