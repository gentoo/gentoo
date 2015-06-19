# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmbiff/wmbiff-0.4.28.ebuild,v 1.4 2015/06/11 14:27:30 ago Exp $

EAPI=5
inherit autotools eutils

DESCRIPTION="WMBiff is a dock applet for WindowMaker which can monitor up to 5 mailboxes"
HOMEPAGE="http://windowmaker.org/dockapps/?name=wmbiff"
# Grab from http://windowmaker.org/dockapps/?download=${P}.tar.gz
SRC_URI="http://dev.gentoo.org/~voyageur/distfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="crypt"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm
	crypt? (
		>=dev-libs/libgcrypt-1.2.1:0
		>=net-libs/gnutls-2.2.0
		)"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	x11-proto/xextproto
	x11-proto/xproto"

S=${WORKDIR}/dockapps

DOCS="ChangeLog FAQ NEWS README TODO wmbiff/sample.wmbiffrc"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.4.27-invalid-strncpy.patch
	eautoreconf
}

src_configure() {
	econf $(use_enable crypt crypto)
}
