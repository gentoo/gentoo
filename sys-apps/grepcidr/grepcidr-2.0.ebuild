# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs

DESCRIPTION="Filter IPv4 and IPv6 addresses matching CIDR patterns"
HOMEPAGE="http://www.pc-tools.net/unix/grepcidr/"
SRC_URI="http://www.pc-tools.net/files/unix/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EROOT}/usr" install

	dodoc README ChangeLog
}
