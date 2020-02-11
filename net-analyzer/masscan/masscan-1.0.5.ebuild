# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit toolchain-funcs

DESCRIPTION="Mass IP port scanner"
HOMEPAGE="https://github.com/robertdavidgraham/masscan"
SRC_URI="https://github.com/robertdavidgraham/masscan/archive/${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="AGPL-3"
KEYWORDS="~amd64 ~x86"

RDEPEND="net-libs/libpcap"

src_prepare(){
	default

	sed -i \
		-e '/$(CC)/s!$(CFLAGS)!$(LDFLAGS) $(CFLAGS)!g' \
		-e '/^GITVER :=/s!= .(.*!=!g' \
		-e '/^SYS/s|gcc|$(CC)|g' \
		-e '/^CFLAGS =/{s,=,+=,;s,-g -ggdb,,;s,-O3,,;}' \
		-e '/^CC =/d' \
		Makefile || die

	tc-export CC
}

src_install() {
	dobin bin/masscan

	insinto /etc/masscan
	doins data/exclude.conf
	doins "${FILESDIR}"/masscan.conf

	dodoc doc/bot.html *.md

	doman doc/masscan.8
}
