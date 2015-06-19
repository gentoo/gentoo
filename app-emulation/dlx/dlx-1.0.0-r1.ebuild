# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/dlx/dlx-1.0.0-r1.ebuild,v 1.4 2012/10/24 10:52:55 ago Exp $

inherit toolchain-funcs

DESCRIPTION="DLX Simulator"
HOMEPAGE="http://www.davidviner.com/dlx.php"
SRC_URI="http://www.davidviner.com/${PN}/${PN}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

S="${WORKDIR}/${PN}"

src_compile() {
	emake CC="$(tc-getCC)" \
		LINK="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LFLAGS="${LDFLAGS}" \
		|| die "emake failed"
}

src_install() {
	dodir /usr/include/dlx /usr/share/dlx/examples
	dobin masm mon dasm
	insinto /usr/include/dlx
	doins *.i auto.a
	insinto /usr/share/dlx/examples
	doins *.a hp.m
	dodoc README.txt MANUAL.TXT
}
