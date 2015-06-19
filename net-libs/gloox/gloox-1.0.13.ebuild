# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/gloox/gloox-1.0.13.ebuild,v 1.1 2015/02/09 16:52:34 mrueg Exp $

EAPI=5

inherit eutils

MY_P="${P/_/-}"
DESCRIPTION="A portable high-level Jabber/XMPP library for C++"
HOMEPAGE="http://camaya.net/gloox"
SRC_URI="http://camaya.net/download/${MY_P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0/13"
KEYWORDS="~alpha ~amd64 ~arm ~ppc ~ppc64 ~ia64 ~sparc ~x86"
IUSE="debug gnutls idn ssl static-libs test zlib"

DEPEND="idn? ( net-dns/libidn )
	gnutls? ( net-libs/gnutls )
	ssl? ( dev-libs/openssl )
	zlib? ( sys-libs/zlib )"

RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch_user
}

src_configure() {
	# Examples are not installed anyway, so - why should we build them?
	econf \
		--without-examples \
		$(use debug && echo "--enable-debug") \
		$(use_enable static-libs static) \
		$(use_with idn libidn) \
		$(use_with gnutls) \
		$(use_with ssl openssl) \
		$(use_with test tests) \
		$(use_with zlib)
}

src_install() {
	default
	prune_libtool_files
}
