# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit base eutils

DESCRIPTION="Client library for accessing ISDS Soap services"
HOMEPAGE="http://xpisar.wz.cz/libisds/"
SRC_URI="http://xpisar.wz.cz/${PN}/dist/${P}.tar.xz"
KEYWORDS="~amd64 ~mips ~x86"

LICENSE="LGPL-3"
SLOT="0"
IUSE="+curl debug nls openssl static-libs test"

COMMON_DEPEND="
	dev-libs/expat
	dev-libs/libxml2
	curl? ( net-misc/curl[ssl] )
	openssl? ( dev-libs/openssl:* )
	!openssl? (
		app-crypt/gpgme
		dev-libs/libgcrypt:*
	)
"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
	test? ( >=net-libs/gnutls-2.12.0 )
"
RDEPEND="${COMMON_DEPEND}
	!openssl? ( >=app-crypt/gnupg-2 )
"

DOCS=( NEWS README AUTHORS ChangeLog )

src_prepare() {
	base_src_prepare
}

src_configure() {
	econf \
		--disable-fatalwarnings \
		$(use_with curl libcurl) \
		$(use_enable curl curlreauthorizationbug) \
		$(use_enable debug) \
		$(use_enable nls) \
		$(use_enable openssl openssl-backend) \
		$(use_enable static-libs static) \
		$(use_enable test)
}

src_install() {
	base_src_install

	prune_libtool_files --all
}
