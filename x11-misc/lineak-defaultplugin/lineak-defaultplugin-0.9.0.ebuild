# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/lineak-defaultplugin/lineak-defaultplugin-0.9.0.ebuild,v 1.7 2011/03/23 16:39:14 signals Exp $

inherit eutils multilib

MY_P=${P/.0/}

DESCRIPTION="Mute/unmute and other macros for LINEAK"
HOMEPAGE="http://lineak.sourceforge.net"
SRC_URI="mirror://sourceforge/lineak/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="debug"

DEPEND="=x11-misc/lineakd-${PV}*
	x11-proto/inputproto"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-gcc43.patch
}

src_compile() {
	econf USER_LDFLAGS="${LDFLAGS}" $(use_enable debug)
	emake || die "emake failed."
}

src_install() {
	sed -i -e 's:$(DESTDIR)${DESTDIR}:$(DESTDIR):' default_plugin/Makefile

	emake DESTDIR="${D}" \
		PLUGINDIR=/usr/$(get_libdir)/lineakd/plugins \
		install || die "emake install failed."
	dodoc AUTHORS README
}
