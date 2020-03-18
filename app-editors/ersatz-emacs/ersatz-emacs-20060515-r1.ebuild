# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A very minimal imitation of the famous GNU Emacs editor"
HOMEPAGE="https://web.archive.org/web/20171126221613/http://hunter.apana.org.au/~cjb/Code/"
# taken from http://hunter.apana.org.au/~cjb/Code/ersatz.tar.gz
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="sys-libs/ncurses:0="
RDEPEND="${DEPEND}
	!app-editors/ee"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}"

src_prepare() {
	eapply "${FILESDIR}"/${P}-gentoo.patch
	sed -i -e "s%/usr/local/share/%/usr/share/doc/${PF}/%" ee.1 \
		|| die "sed failed"
	eapply_user
}

src_compile() {
	emake CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS} -Wall" \
		LFLAGS="${LDFLAGS} $("$(tc-getPKG_CONFIG)" --libs ncurses)"
}

src_install() {
	# Note: /usr/bin/ee is "easy edit" on FreeBSD, so if this
	# is ever keyworded *-fbsd the binary has to be renamed.
	dobin ee
	doman ee.1
	dodoc ChangeLog ERSATZ.keys README
}
