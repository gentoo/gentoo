# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/thc-ipv6/thc-ipv6-2.5.ebuild,v 1.1 2014/07/30 22:20:07 xmw Exp $

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="complete tool set to attack the inherent protocol weaknesses of IPV6 and ICMP6"
HOMEPAGE="http://freeworld.thc.org/thc-ipv6/"
SRC_URI="http://freeworld.thc.org/releases/${P}.tar.gz"

LICENSE="AGPL-3 openssl"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ssl"

DEPEND="net-libs/libpcap
	ssl? ( dev-libs/openssl )"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.1-Makefile.patch
	if ! use ssl ; then
		sed -e '/^HAVE_SSL/s:^:#:' \
			-i Makefile
	fi
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" STRIP="true" install
	dodoc CHANGES HOWTO-INJECT README
}
