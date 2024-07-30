# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="dockapp for checking up to 7 pop3 accounts"
HOMEPAGE="https://www.dockapps.net/wmpop3lb"
SRC_URI="https://www.dockapps.net/download/${P/-}.tar.gz"
S="${WORKDIR}/${P/-}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~sparc x86"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-fix-RECV-and-try-STAT-if-LAST-wont-work.patch
	"${FILESDIR}"/${P}-list.patch
	"${FILESDIR}"/${P}-gcc-10.patch )

src_prepare() {
	#Honour Gentoo CFLAGS
	sed -i -e "s|-g2 -D_DEBUG|${CFLAGS}|" "wmpop3/Makefile" || die

	#De-hardcode compiler
	sed -i -e "s|\tcc |\t\$(CC) |g" "wmpop3/Makefile" || die

	#Honour Gentoo LDFLAGS - bug #335986
	sed -i -e "s|\$(FLAGS) -o wmpop3lb|\$(LDFLAGS) -o wmpop3lb|" "wmpop3/Makefile" || die
	default
}

src_compile() {
	emake -C wmpop3
}

src_install() {
	dobin wmpop3/wmpop3lb
	dodoc CHANGE_LOG README
}
