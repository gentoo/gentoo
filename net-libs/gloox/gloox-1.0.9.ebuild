# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/gloox/gloox-1.0.9.ebuild,v 1.9 2015/07/03 10:09:14 ago Exp $

EAPI=5

MY_P=${P/_/-}
DESCRIPTION="A portable high-level Jabber/XMPP library for C++"
HOMEPAGE="http://camaya.net/gloox"
SRC_URI="http://camaya.net/download/${MY_P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ia64 ppc ~ppc64 ~sparc x86"
IUSE="debug gnutls idn ssl zlib"

DEPEND="idn? ( net-dns/libidn )
	gnutls? ( net-libs/gnutls )
	ssl? ( dev-libs/openssl )
	zlib? ( sys-libs/zlib )"

RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_configure() {
	econf \
		$(use_enable debug debug) \
		$(use_with idn libidn) \
		$(use_with gnutls gnutls) \
		$(use_with ssl openssl) \
		$(use_with zlib zlib)
}

src_install() {
	emake DESTDIR="${D}" install
}
