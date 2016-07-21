# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

DESCRIPTION="PKCS#11 support for GnuPG"
HOMEPAGE="http://gnupg-pkcs11.sourceforge.net"
SRC_URI="mirror://sourceforge/gnupg-pkcs11/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libressl"

RDEPEND="
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	=dev-libs/libassuan-2*
	>=dev-libs/libgcrypt-1.2.2:0
	>=dev-libs/libgpg-error-1.3
	>=dev-libs/pkcs11-helper-1.02"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	econf --docdir="/usr/share/doc/${PF}"
}
