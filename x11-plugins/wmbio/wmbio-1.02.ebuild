# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmbio/wmbio-1.02.ebuild,v 1.12 2010/09/01 07:16:26 s4t4n Exp $

EAPI=2
inherit eutils

DESCRIPTION="A Window Maker applet that shows your biorhythm"
SRC_URI="http://wmbio.sourceforge.net/${P}.tar.gz"
HOMEPAGE="http://wmbio.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc ppc64 sparc x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xextproto"

S=${WORKDIR}/${P}/src

src_prepare() {
	# Honour Gentoo CFLAGS
	sed -i "s/-g -O2/\$(CFLAGS)/" Makefile

	# Honour Gentoo LDFLAGS
	sed -i "s/-o wmbio/\$(LDFLAGS) -o wmbio/" Makefile
}

src_compile() {
	emake || die "emake failed"
}

src_install () {
	dobin wmbio || die "dobin failed"
	dodoc ../{AUTHORS,Changelog,NEWS,README} || die
}
