# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/iip/iip-1.2.ebuild,v 1.11 2010/10/19 21:15:30 flameeyes Exp $

EAPI="2"

inherit eutils

MY_P="${P}-dev1"

DESCRIPTION="Proxy server for encrypted anonymous IRC-like network"
HOMEPAGE="http://www.invisiblenet.net/iip/"
SRC_URI="mirror://sourceforge/invisibleip/${MY_P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc"
IUSE=""

RDEPEND="dev-libs/openssl"
DEPEND="${RDEPEND}
	dev-lang/perl
	>=sys-apps/sed-4"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}/iip_open_mode.patch"
}

src_compile() {
	sed -i \
		-e "s:-Werror::" "${S}"/src/Makefile || \
		die "sed Makefile failed"

	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS README
}
