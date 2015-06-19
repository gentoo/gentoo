# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/siefs/siefs-0.5-r2.ebuild,v 1.3 2012/02/16 19:21:45 phajdan.jr Exp $

inherit eutils autotools

DESCRIPTION="Siemens FS"
HOMEPAGE="http://chaos.allsiemens.com/siefs"
SRC_URI="http://chaos.allsiemens.com/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND="sys-fs/fuse"
RDEPEND="${DEPEND}
	app-mobilephone/vmoconv"

src_unpack() {
	unpack ${A}

	cd "${S}"
	epatch "${FILESDIR}"/${P}-qa-fixes.patch
	epatch "${FILESDIR}"/${P}-external-vmoconv.patch

	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc README AUTHORS
}
