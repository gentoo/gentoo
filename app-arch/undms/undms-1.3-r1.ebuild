# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/undms/undms-1.3-r1.ebuild,v 1.1 2010/09/20 02:55:31 jer Exp $

inherit toolchain-funcs

DESCRIPTION="Decompress Amiga DMS disk images to ADF"
SRC_URI="ftp://us.aminet.net/pub/aminet/misc/unix/${P}.c.Z ftp://us.aminet.net/pub/aminet/misc/unix/${P}.c.Z.readme"
HOMEPAGE="ftp://us.aminet.net/pub/aminet/misc/unix/"
LICENSE="freedist"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-interix ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"
IUSE=""

S="${WORKDIR}"

src_compile() {
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} -o ${PN} ${P}.c || die "Compilation failed"
}

src_install() {
	dobin undms
	newdoc "${DISTDIR}"/${P}.c.Z.readme readme
}
