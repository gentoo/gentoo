# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/bird/bird-1.4.4.ebuild,v 1.1 2014/07/23 08:48:49 chainsaw Exp $

EAPI=5

DESCRIPTION="A routing daemon implementing OSPF, RIPv2 & BGP for IPv4 or IPv6"
HOMEPAGE="http://bird.network.cz"
SRC_URI="ftp://bird.network.cz/pub/${PN}/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug ipv6"

RDEPEND="sys-libs/ncurses
	sys-libs/readline"
DEPEND="sys-devel/flex
	sys-devel/bison
	sys-devel/m4"

src_prepare() {
	mkdir ipv6
	tar c --exclude ipv6 . | tar x -C ipv6
}

src_configure() {
	econf \
		--enable-client \
		--disable-ipv6 \
		--localstatedir="${EPREFIX}/var" \
		$(use_enable debug)

	if use ipv6; then
		cd ipv6
		econf \
			--enable-client \
			--enable-ipv6 \
			--localstatedir="${EPREFIX}/var" \
			$(use_enable debug)
	fi
}

src_compile() {
	emake
	if use ipv6; then
		cd ipv6
		emake
	fi
}

src_install() {
	if use ipv6; then
		newbin ipv6/birdc birdc6
		newsbin ipv6/bird bird6
		newinitd "${FILESDIR}/initd-v6-${PN}-1.3.8" bird6
	fi
	dobin birdc
	dosbin bird
	newinitd "${FILESDIR}/initd-v4-${PN}-1.3.8" bird
	dodoc doc/bird.conf.example
}
