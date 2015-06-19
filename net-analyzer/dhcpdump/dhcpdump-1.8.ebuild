# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/dhcpdump/dhcpdump-1.8.ebuild,v 1.4 2014/06/24 18:46:44 jer Exp $

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="DHCP Packet Analyzer/tcpdump postprocessor"
HOMEPAGE="http://www.mavetju.org/unix/general.php"
SRC_URI="http://www.mavetju.org/download/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~mips"

RDEPEND="net-libs/libpcap"
DEPEND="
	${RDEPEND}
	dev-lang/perl
"

src_prepare() {
	epatch "${FILESDIR}"/${P}-Makefile.patch
	epatch "${FILESDIR}"/${P}-debian.patch
	epatch "${FILESDIR}"/${P}-endianness.patch
}

src_compile() {
	emake CC=$(tc-getCC)
}

src_install () {
	dobin ${PN}
	doman ${PN}.8
	dodoc CHANGES CONTACT
}
