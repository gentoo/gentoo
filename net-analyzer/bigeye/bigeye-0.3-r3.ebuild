# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/bigeye/bigeye-0.3-r3.ebuild,v 1.6 2014/07/10 19:36:29 jer Exp $

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="network utility dump and simple honeypot utility"
HOMEPAGE="http://violating.us/projects/bigeye/"
SRC_URI="http://violating.us/projects/bigeye/download/${P}.tgz
	mirror://gentoo/${P}-gcc34.diff.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

src_prepare() {
	epatch \
		"${WORKDIR}"/${P}-gcc34.diff \
		"${FILESDIR}"/${P}-overflow.patch
	sed -i README \
		-e "s|-- /messages/|-- /usr/share/bigeye/messages/|g" \
		|| die "sed README"
}

src_compile() {
	cd src || die
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} bigeye.c emulate.c -o bigeye || die
}

src_install() {
	dobin src/bigeye

	insinto /usr/share/bigeye
	doins sig.file
	doins -r messages

	dodoc README
}
