# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils multilib

MY_P=${P/.0/}

DESCRIPTION="Mute/unmute and other macros for LINEAK"
HOMEPAGE="http://lineak.sourceforge.net"
SRC_URI="mirror://sourceforge/lineak/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="debug"

RDEPEND="
	=x11-misc/lineakd-${PV}*
"
DEPEND="
	${RDEPEND}
	x11-proto/inputproto
"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-gcc43.patch \
		"${FILESDIR}"/${P}-gcc47.patch

	sed -i -e 's:$(DESTDIR)${DESTDIR}:$(DESTDIR):' default_plugin/Makefile.in || die
}

src_configure() {
	econf USER_LDFLAGS="${LDFLAGS}" $(use_enable debug)
}

src_install() {
	emake \
		DESTDIR="${D}" \
		PLUGINDIR=/usr/$(get_libdir)/lineakd/plugins \
		install
	dodoc AUTHORS README
}
