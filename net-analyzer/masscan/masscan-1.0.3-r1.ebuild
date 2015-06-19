# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/masscan/masscan-1.0.3-r1.ebuild,v 1.2 2014/07/13 13:31:10 jer Exp $

EAPI=5
inherit toolchain-funcs

DESCRIPTION="Mass IP port scanner"
HOMEPAGE="https://github.com/robertdavidgraham/masscan"
SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="AGPL-3"
KEYWORDS="~amd64 ~x86"

RDEPEND="net-libs/libpcap"
DEPEND="${RDEPEND}"

src_prepare(){
	sed -i \
		-e '/$(CC)/s!$(CFLAGS)!$(LDFLAGS) $(CFLAGS)!g' \
		-e '/^GITVER :=/s!= .(.*!=!g' \
		-e '/^SYS/s|gcc|$(CC)|g' \
		-e '/$(CC)/s!-DGIT=\"$(GITVER)\"!!g' \
		-e '/^CFLAGS =/{s,=,+=,;s,-g -ggdb,,;s,-O3,,;}' \
		Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	emake CC="$(tc-getCC)" DESTDIR="${D}" PREFIX=/usr install

	insinto /etc/masscan
	doins data/exclude.conf
	doins "${FILESDIR}"/masscan.conf

	mv doc/bot.{hml,html} || die
	dohtml doc/bot.html
	doman doc/masscan.8
	dodoc *.md
}
