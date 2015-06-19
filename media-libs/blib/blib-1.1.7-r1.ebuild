# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/blib/blib-1.1.7-r1.ebuild,v 1.6 2012/05/05 08:02:44 jdhore Exp $

EAPI=2

DESCRIPTION="blib is a library full of useful things to hack the Blinkenlights"
HOMEPAGE="http://www.blinkenlights.de"
SRC_URI="http://www.blinkenlights.de/dist/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="aalib gtk directfb"

RDEPEND=">=dev-libs/glib-2
	aalib? ( >=media-libs/aalib-1.4_rc4-r2 )
	directfb? ( >=dev-libs/DirectFB-0.9.20-r1 )
	gtk? ( >=x11-libs/gtk+-2.4.4:2 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	# Drop DEPRECATED flags, bug #391105
	sed -i -e 's:-D[A-Z_]*DISABLE_DEPRECATED:$(NULL):g' \
		blib/Makefile.am blib/Makefile.in \
		gfx/Makefile.am gfx/Makefile.in \
		modules/Makefile.am modules/Makefile.in \
		test/modules/Makefile.am test/modules/Makefile.in || die
}

src_configure() {
	econf \
		$(use_enable aalib) \
		$(use_enable directfb) \
		$(use_enable gtk gtk2)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README
}
