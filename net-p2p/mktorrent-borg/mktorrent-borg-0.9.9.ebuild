# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/mktorrent-borg/mktorrent-borg-0.9.9.ebuild,v 1.1 2008/05/05 15:09:43 armin76 Exp $

inherit eutils toolchain-funcs

DESCRIPTION="Console .torrent file creator. It support Multi Trackers (tier groups)"
HOMEPAGE="http://borg.uu3.net/~borg/"
SRC_URI="ftp://borg.uu3.net/pub/unix/mktorrent/mktorrent-${PV}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

S="${WORKDIR}/${PN%-borg}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	sed -i -e "s/CC=gcc/CC=$(tc-getCC)/g" \
		-e "s/^CFLAGS =/CFLAGS +=/g" Makefile
}

src_install() {
	newbin mktorrent mktorrent-borg || die "newbin failed"
	dodoc CHANGES
}
