# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/xzgv/xzgv-0.9.1.ebuild,v 1.7 2014/02/15 12:57:00 ssuominen Exp $

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="Fast and simple GTK+ image viewer"
HOMEPAGE="http://sourceforge.net/projects/xzgv"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc64 x86"
IUSE=""

RDEPEND="x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	sys-apps/texinfo
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${P/.1}-asneeded-and-cflags.patch
}

src_compile() {
	emake CC="$(tc-getCC)"
	emake -C doc CC="$(tc-getCC)"
}

src_install() {
	emake PREFIX="${D}/usr" install
	dodoc AUTHORS NEWS README TODO
}
