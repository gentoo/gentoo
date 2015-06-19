# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xwrits/xwrits-2.26.ebuild,v 1.7 2014/08/10 20:05:39 slyfox Exp $

DESCRIPTION="Reminds you to take wrist breaks, which will hopefully help you prevent repetitive stress injury"
HOMEPAGE="http://www.lcdf.org/xwrits/"
SRC_URI="http://www.lcdf.org/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXinerama"
DEPEND="${RDEPEND}
	x11-proto/xproto
	x11-proto/xineramaproto"

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc GESTURES NEWS README TODO
}
