# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
