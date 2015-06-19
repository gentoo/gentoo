# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/idesk/idesk-0.7.5-r2.ebuild,v 1.7 2012/05/05 04:53:42 jdhore Exp $

EAPI=4
inherit eutils

DESCRIPTION="Utility to place icons on the root window"
HOMEPAGE="http://idesk.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc ppc64 sparc x86"
IUSE=""

RDEPEND=">=media-libs/imlib2-1.4[X]
	media-libs/freetype
	dev-libs/libxml2
	dev-libs/glib:2
	x11-libs/pango
	x11-libs/gtk+:2
	media-libs/libart_lgpl
	x11-libs/startup-notification"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS NEWS README TODO )

src_prepare() {
	sed -i \
		-e 's,/usr/local/,/usr/,' \
		examples/default.lnk || die
	epatch "${FILESDIR}"/${P}-glibc-2.12.patch #333515
}

src_configure() {
	econf --enable-libsn
}
