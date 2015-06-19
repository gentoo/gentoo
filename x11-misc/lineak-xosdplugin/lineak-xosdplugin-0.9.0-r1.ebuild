# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/lineak-xosdplugin/lineak-xosdplugin-0.9.0-r1.ebuild,v 1.4 2012/02/16 19:33:53 phajdan.jr Exp $

inherit eutils multilib

MY_P=${P/.0/}

DESCRIPTION="Xosd plugin for LINEAK"
HOMEPAGE="http://lineak.sourceforge.net/"
SRC_URI="mirror://sourceforge/lineak/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="debug"

DEPEND="=x11-misc/lineakd-${PV}*
		x11-libs/xosd"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-gcc43.patch
}

src_compile() {
	econf $(use_enable debug) --with-x
	emake LDFLAGS="${LDFLAGS}" || die
}

src_install() {
	emake DESTDIR="${D}" \
		PLUGINDIR=/usr/$(get_libdir)/lineakd/plugins \
		install || die
	dodoc AUTHORS README || die
}
