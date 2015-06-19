# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/pimpd/pimpd-0.8.ebuild,v 1.17 2012/11/21 17:58:54 ago Exp $

EAPI=4

inherit toolchain-funcs

DESCRIPTION="RFC1413-compliant identd server supporting masqueraded connections"
HOMEPAGE="http://gentoo.org"
SRC_URI="http://cats.meow.at/~peter/pimpd_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc sparc x86"
IUSE=""

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	dosbin pimpd
	dodoc README
}
