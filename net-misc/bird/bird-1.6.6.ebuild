# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A routing daemon implementing OSPF, RIPv2 & BGP for IPv4 or IPv6"
HOMEPAGE="http://bird.network.cz"
SRC_URI="ftp://bird.network.cz/pub/${PN}/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86 ~x64-macos"
IUSE="+client debug ipv6"

RDEPEND="client? ( sys-libs/ncurses )
	client? ( sys-libs/readline )"
DEPEND="sys-devel/flex
	sys-devel/bison
	sys-devel/m4"

src_prepare() {
	eapply_user
	mkdir ipv6
	tar c --exclude ipv6 . | tar x -C ipv6
}

src_configure() {
	econf \
		--disable-ipv6 \
		--localstatedir="${EPREFIX}/var" \
		$(use_enable client) \
		$(use_enable debug)

	if use ipv6; then
		cd ipv6
		econf \
			--enable-ipv6 \
			--localstatedir="${EPREFIX}/var" \
			$(use_enable client) \
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
		if use client; then
			newbin ipv6/birdc birdc6
		fi
		newbin ipv6/birdcl birdcl6
		newsbin ipv6/bird bird6
		newinitd "${FILESDIR}/initd-${PN}-2" bird6
	fi
	if use client; then
		dobin birdc
	fi
	dobin birdcl
	dosbin bird
	newinitd "${FILESDIR}/initd-${PN}-2" bird
	dodoc doc/bird.conf.example
}
