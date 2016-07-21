# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="an active sniffer that provides methods for aggressive sniffing on switched LANs"
HOMEPAGE="http://angst.sourceforge.net/"
SRC_URI="http://angst.sourceforge.net/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"

DEPEND="net-libs/libpcap
	net-libs/libnet:1.0"
RDEPEND="${DEPEND}"

src_prepare() {
	cp -av Makefile.linux{,.orig}
	epatch "${FILESDIR}"/${PV}-libnet-1.0.patch
	sed -i Makefile.linux \
		-e 's|^CC =|CC ?=|g' \
		-e '/ -o angst /s|$(OBJS)|$(LDFLAGS) &|g' \
		|| die
}

src_compile() {
	emake \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		CC="$(tc-getCC)" \
		-f Makefile.linux
}

src_install() {
	dosbin angst
	doman angst.8
	dodoc README TODO ChangeLog
}
