# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/pkcs11-dump/pkcs11-dump-0.3.4.ebuild,v 1.2 2012/05/03 18:16:39 jdhore Exp $

EAPI=4

DESCRIPTION="Utilities for PKCS#11 token content dump"
HOMEPAGE="http://sites.google.com/site/alonbarlev/pkcs11-utilities"
SRC_URI="http://pkcs11-tools.googlecode.com/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64"

IUSE=""

RDEPEND=">=dev-libs/openssl-0.9.7:0"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	econf \
		--docdir=/usr/share/doc/${PF}
}
