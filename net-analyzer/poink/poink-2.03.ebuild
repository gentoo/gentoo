# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="TCP/IP-based ping implementation"
HOMEPAGE="https://directory.fsf.org/security/system/poink.html"
SRC_URI="https://ep09.pld-linux.org/~mmazur/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

PATCHES=( "${FILESDIR}/${PN}-2.03-signed-char-fixup.patch" )

src_compile() {
	emake \
	CFLAGS="${CFLAGS} ${LDFLAGS}" \
	CC="$(tc-getCC)"
}

src_install() {
	dobin poink poink6
	newman ping.1 poink.1
	dodoc README* ChangeLog
}
