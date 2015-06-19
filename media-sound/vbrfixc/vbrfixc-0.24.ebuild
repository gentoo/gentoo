# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/vbrfixc/vbrfixc-0.24.ebuild,v 1.6 2013/01/24 21:14:57 sbriesen Exp $

EAPI=2
inherit eutils

DESCRIPTION="Vbrfix fixes MP3s and re-constructs VBR headers"
HOMEPAGE="http://home.gna.org/vbrfix/"
SRC_URI="ftp://mirror.bytemark.co.uk/gentoo/distfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
# bin endian ones need vbrfixc-0.24-bigendian.diff from gentoo-x86 cvs Attic
KEYWORDS="amd64 x86"
IUSE=""
DEPEND=""
RDEPEND=""

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc43.patch

}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS README TODO
	dohtml vbrfixc/docs/en/*.html
}
