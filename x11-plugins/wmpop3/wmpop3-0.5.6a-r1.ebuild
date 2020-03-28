# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils toolchain-funcs

DESCRIPTION="dockapp for checking pop3 accounts"
HOMEPAGE="https://www.dockapps.net/wmpop3"
SRC_URI="https://www.dockapps.net/download/${P/wmpop3/WMPop3}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~sparc x86"
IUSE=""

DEPEND="x11-wm/windowmaker
	x11-libs/libXpm"
RDEPEND="${DEPEND}"

PATCHES=( ${FILESDIR}/${P}-list.patch )

src_prepare() {
	sed -e "s|cc |$(tc-getCC) |" \
		-e "s|-O2|${CFLAGS}|" \
		-e "s|-o wmpop3|${LDFLAGS} -o wmpop3|" \
		-i ${PN}/Makefile || die

	default
}

src_compile() {
	emake -C wmpop3
}

src_install() {
	dobin wmpop3/wmpop3
	dodoc CHANGE_LOG README
}
