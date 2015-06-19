# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dns/sheerdns/sheerdns-1.0.3.ebuild,v 1.1 2013/12/16 06:37:48 patrick Exp $

EAPI="5"

inherit eutils toolchain-funcs multilib

DESCRIPTION="Sheerdns is a small, simple, fast master only DNS server"
HOMEPAGE="http://threading.2038bug.com/sheerdns/"
SRC_URI="http://threading.2038bug.com/sheerdns/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""
DEPEND=""

S="${WORKDIR}/${PN}"

src_prepare() {
	# Fix multilib support
	sed -i "/^CFLAGS/s:usr/lib:usr/$(get_libdir):" Makefile
}

src_compile() {
	emake CC=$(tc-getCC) || die
}

src_install() {
	dodoc ChangeLog
	doman sheerdns.8
	dosbin sheerdns sheerdnshash
}
