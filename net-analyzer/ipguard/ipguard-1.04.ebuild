# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/ipguard/ipguard-1.04.ebuild,v 1.1 2014/10/13 22:33:02 jer Exp $

EAPI=5
inherit toolchain-funcs

DESCRIPTION="Tool designed to protect LAN IP adress space by ARP spoofing"
HOMEPAGE="http://ipguard.deep.perm.ru/"
SRC_URI="${HOMEPAGE}files/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	net-libs/libnet
	net-libs/libpcap
"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i \
		-e 's|-g ||g' \
		-e 's|	@$(CC)|	$(CC)|g' \
		-e 's| -s | |g' \
		-e 's| -o | $(CFLAGS) $(LDFLAGS)&|g' \
		-e 's|$(PREFIX)|${D}&|g' \
		-e 's|/man/|/share&|g' \
		Makefile || die
	sed -i \
		-e 's|opts=|extra_commands=|g' \
		-e 's|/var/run/|/run/|g' \
		-e 's|-u 300 -xz|${OPTS} ${IFACE}|g' \
		doc/${PN}.gentoo || die
	sed -i \
		-e 's|/var/run/|/run/|g' \
		doc/${PN}.8 ${PN}.h || die
}

src_compile() {
	emake LIBNET_CONFIG=libnet-config CC=$(tc-getCC) PREFIX=\"${EPREFIX:-/usr}\"
}

src_install() {
	emake LIBNET_CONFIG=libnet-config DESTDIR="${D}" PREFIX=\"${EPREFIX:-/usr}\" install
	newinitd doc/${PN}.gentoo ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	dodoc doc/{NEWS,README*,ethers.sample}
}
