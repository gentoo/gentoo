# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit autotools eutils

DESCRIPTION="SMTP and POP mailserver benchmark. Supports SSL, randomized user accounts and more"
HOMEPAGE="http://www.coker.com.au/postal/"
SRC_URI="http://www.coker.com.au/postal/${P}.tgz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~sparc ~x86"
IUSE="ssl gnutls"
#ssl is an alias for openssl. If both ssl and gnutls are enabled, automagic will
#enable only gnutls.
DEPEND="ssl? (
	!gnutls? ( >=dev-libs/openssl-0.9.8g )
	gnutls? ( >=net-libs/gnutls-2.2.2 )
	)"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/01_${PN}-0.70-gcc43.patch"
	epatch "${FILESDIR}/02_${PN}-0.72-nossl.patch"
	epatch "${FILESDIR}/03_${PN}-0.70-c++0x-integrated.patch"
	epatch "${FILESDIR}/04_${PN}-0.70-warnings.patch"
	epatch "${FILESDIR}/05_${PN}-0.70-openssl-1.patch"
	epatch "${FILESDIR}/06_${PN}-0.70-ldflags.patch"
	eautoreconf
}

src_configure() {
	econf \
		--disable-stripping \
		$(use_enable ssl openssl) \
		$(use_enable gnutls)
}
