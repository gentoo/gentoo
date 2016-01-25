# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils

DESCRIPTION="Lightweight C Jabber library"
HOMEPAGE="https://github.com/mcabber/loudmouth"
SRC_URI="https://github.com/mcabber/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~ppc-macos"

IUSE="asyncns ssl openssl static-libs test"

# Automagic libidn dependency
RDEPEND="
	>=dev-libs/glib-2.16:2
	net-dns/libidn
	ssl? (
		!openssl? ( >=net-libs/gnutls-1.4.0 )
		openssl? ( dev-libs/openssl:0 )
	)
	asyncns? ( >=net-libs/libasyncns-0.3 )
"
DEPEND="${RDEPEND}
	test? ( dev-libs/check )
	virtual/pkgconfig
	>=dev-util/gtk-doc-am-1
"

src_prepare() {
	eautoreconf
}

src_configure() {
	local myconf

	if use ssl; then
		if ! use openssl; then
			myconf="${myconf} --with-ssl=gnutls"
		else
			myconf="${myconf} --with-ssl=openssl"
		fi
	else
		myconf="${myconf} --with-ssl=no"
	fi

	econf \
		$(use_enable static-libs static) \
		$(use_with asyncns) \
		${myconf}
}
