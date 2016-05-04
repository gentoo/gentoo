# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit toolchain-funcs

DESCRIPTION="redirects TCP connections from one IP address and port to another"
HOMEPAGE="http://www.boutell.com/rinetd/"
SRC_URI="http://www.boutell.com/rinetd/http/rinetd.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

S=${WORKDIR}/${PN}

src_prepare() {
	default
	sed -i -e "s:gcc:$(tc-getCC) \$(CFLAGS) \$(LDFLAGS):" Makefile
}

src_compile() {
	emake CFLAGS="${CFLAGS} -DLINUX" LDFLAGS="${LDFLAGS}"
}

src_install() {
	dosbin rinetd
	newinitd "${FILESDIR}"/rinetd.rc rinetd
	doman rinetd.8
	dodoc CHANGES README index.html
}
