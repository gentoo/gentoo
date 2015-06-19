# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/g15mpd/g15mpd-1.0.0-r1.ebuild,v 1.1 2014/01/17 18:48:48 creffett Exp $

EAPI=5
inherit autotools eutils

DESCRIPTION="MPD (music player daemon) plugin to G15daemon"
HOMEPAGE="http://g15daemon.sourceforge.net/"
SRC_URI="mirror://sourceforge/g15daemon/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="
	>=app-misc/g15daemon-1.9
	dev-libs/libg15
	dev-libs/libg15render
	>=media-libs/libmpd-0.17
	sys-libs/zlib
	x11-libs/libX11
	x11-libs/libXtst
"
DEPEND="${RDEPEND}
	x11-proto/xproto
	x11-proto/xextproto"

src_prepare() {
	epatch "${FILESDIR}"/${P}-libmpd.patch
	epatch "${FILESDIR}/${PN}-1.0.0-cflags-and-lib-fix.patch"
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	rm "${D}"/usr/share/doc/${P}/{COPYING,NEWS}
}
