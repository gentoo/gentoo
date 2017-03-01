# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

DESCRIPTION="PKCS#11 support for GnuPG"
HOMEPAGE="http://gnupg-pkcs11.sourceforge.net"
SRC_URI="https://github.com/alonbl/${PN}/releases/download/${P}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libressl"

RDEPEND="
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	dev-libs/libassuan:0=
	>=dev-libs/libgcrypt-1.2.2:0=
	>=dev-libs/libgpg-error-1.3
	>=dev-libs/pkcs11-helper-1.02"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
