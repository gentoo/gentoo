# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/uif2iso/uif2iso-0.1.4.ebuild,v 1.3 2008/12/03 22:22:06 maekke Exp $

inherit eutils toolchain-funcs

DESCRIPTION="Converts MagicISO CD-images to iso"
HOMEPAGE="http://aluigi.org/mytoolz.htm#uif2iso"
SRC_URI="mirror://gentoo/${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-libs/openssl
	sys-libs/zlib"
DEPENED="${RDEPEND}
	app-arch/unzip"

S="${WORKDIR}/src"

src_compile() {
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} -o ${PN} ${PN}.c -lz -lcrypto || die "failed to compile"
}

src_install() {
	dobin ${PN} || die "failed to install"

	dodoc "${WORKDIR}"/${PN}.txt
}
