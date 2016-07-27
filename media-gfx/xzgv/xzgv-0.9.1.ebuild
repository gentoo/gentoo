# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="Fast and simple GTK+ image viewer"
HOMEPAGE="https://sourceforge.net/projects/xzgv"
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
