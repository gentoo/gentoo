# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/wepattack/wepattack-0.1.3-r3.ebuild,v 1.4 2014/07/19 00:59:00 jer Exp $

EAPI=5
inherit eutils toolchain-funcs

MY_P="WepAttack-${PV}"
DESCRIPTION="WLAN tool for breaking 802.11 WEP keys"
HOMEPAGE="http://wepattack.sourceforge.net/"
SRC_URI="mirror://sourceforge/wepattack/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="john"

DEPEND="
	dev-libs/openssl
	net-libs/libpcap
	sys-libs/zlib
"

RDEPEND="${DEPEND}
	john? ( app-crypt/johntheripper )"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-filter-mac-address.patch
	epatch "${FILESDIR}"/${P}-missed-string.h-warnings-fix.patch
	chmod +x src/wlan
	sed -i \
		-e "/^CFLAGS=/s:=:=${CFLAGS} :" \
		-e 's:-fno-for-scope::g' \
		-e "/^CC=/s:gcc:$(tc-getCC):" \
		-e "/^LD=/s:gcc:$(tc-getCC):" \
		-e 's:log.o\\:log.o \\:' \
		src/Makefile || die
	sed -i \
		-e "s/wordfile:/-wordlist=/" \
		run/wepattack_word || die
}

src_compile() {
	emake -C src
}

src_install() {
	dobin src/wepattack
	if use john; then
		dosbin run/wepattack_{inc,word}
		insinto /etc
		doins "${FILESDIR}"/wepattack.conf
	fi
	dodoc README
}
