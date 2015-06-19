# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libstroke/libstroke-0.5.1.ebuild,v 1.24 2012/04/25 16:24:18 jlec Exp $

inherit eutils autotools

DESCRIPTION="A Stroke and Gesture recognition Library"
HOMEPAGE="http://www.etla.net/libstroke/"
SRC_URI="http://www.etla.net/libstroke/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND="x11-libs/libX11"
DEPEND="x11-proto/xproto
	${RDEPEND}"

src_unpack() {
	unpack "${A}"
	cd "${S}"
	epatch "${FILESDIR}"/${P}-m4_syntax.patch
	epatch "${FILESDIR}"/${P}-no_gtk1.patch
	epatch "${FILESDIR}"/${P}-autotools.patch
	eautoreconf
}

src_install () {
	emake DESTDIR=${D} install || die
	dodoc CREDITS ChangeLog README
}
