# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/pidgin-encryption/pidgin-encryption-3.1.ebuild,v 1.11 2012/05/05 05:11:58 jdhore Exp $

EAPI=4

inherit flag-o-matic eutils

DESCRIPTION="Pidgin IM Encryption PlugIn"
HOMEPAGE="http://pidgin-encrypt.sourceforge.net/"
SRC_URI="mirror://sourceforge/pidgin-encrypt/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa ppc ~ppc64 sparc x86 ~x86-fbsd"
IUSE="nls"

RDEPEND="net-im/pidgin[gtk]
	x11-libs/gtk+:2
	>=dev-libs/nss-3.11"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}/${P}-glib2.32.patch"
}

src_configure() {
	strip-flags
	replace-flags -O? -O2
	econf $(use_enable nls)
}

src_install() {
	emake install DESTDIR="${D}"
	dodoc CHANGELOG INSTALL NOTES README TODO VERSION WISHLIST
}
