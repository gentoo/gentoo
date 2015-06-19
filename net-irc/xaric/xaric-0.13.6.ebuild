# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/xaric/xaric-0.13.6.ebuild,v 1.2 2014/11/23 10:37:44 jer Exp $

EAPI=5
inherit autotools eutils

DESCRIPTION="An IRC client similar to ircII, BitchX, or ircII EPIC"
HOMEPAGE="http://xaric.org/"
SRC_URI="http://xaric.org/software/${PN}/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="sys-libs/ncurses
	dev-libs/openssl"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS ChangeLog README )

src_prepare() {
	epatch "${FILESDIR}"/${P}-tinfo.patch
	eautoreconf
}

src_install() {
	default
	doicon xaric.xpm
}
