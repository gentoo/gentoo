# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libdexter/libdexter-0.2.1-r1.ebuild,v 1.1 2014/01/01 19:21:04 pacho Exp $

EAPI=5
inherit gnome2-utils eutils

DESCRIPTION="A plugin-based, distributed sampling library"
HOMEPAGE="http://libdexter.sourceforge.net/"
SRC_URI="mirror://sourceforge/libdexter/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# gnutls disabled as will break with gnutls-3, bug #456306
IUSE="tcpd" #gnutls

#gnutls? ( >=net-libs/gnutls-1.4.4:= )
RDEPEND="
	tcpd? ( sys-apps/tcp-wrappers:= )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=dev-libs/glib-2.30:2
"

src_prepare() {
	gnome2_disable_deprecation_warning
}

src_configure() {
	econf \
		$(use_enable tcpd tcp-wrappers) \
		--disable-tls
#		$(use_enable gnutls tls)
}

src_install() {
	default
	prune_libtool_files --modules
}
