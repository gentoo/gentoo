# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

MY_P=irc${PV/_/}
DESCRIPTION="A simplistic RFC compliant IRC client"
HOMEPAGE="http://www.irc.org"
SRC_URI="ftp://ftp.irc.org/irc/server/${MY_P}.tgz"
LICENSE="GPL-1"
SLOT="0"

KEYWORDS="~amd64 ppc x86"
IUSE="ipv6"

DEPEND="sys-libs/ncurses
	sys-libs/zlib"
# This and ircci both install /usr/bin/irc #247987
RDEPEND="${DEPEND}
	!net-irc/ircii"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}

	cd "${S}" || die
	epatch "${FILESDIR}"/${P}-amd64-chost.patch
}

src_compile () {
	econf \
		$(use_with ipv6 ip6) \
		--sysconfdir=/etc/ircd \
		--localstatedir=/var/run/ircd \
		|| die "econf failed"
	emake -C ${CHOST} client || die "client build failed"
}

src_install() {
	make -C ${CHOST} \
		prefix=${D}/usr \
		client_man_dir=${D}/usr/share/man/man1 \
		install-client || die "client installed failed"
	dodoc doc/Etiquette doc/alt-irc-faq doc/rfc* || die
}
