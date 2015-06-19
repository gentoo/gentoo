# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/gnupg-pkcs11-scd/gnupg-pkcs11-scd-0.7.2.ebuild,v 1.3 2014/03/01 22:27:46 mgorny Exp $

EAPI="3"

DESCRIPTION="PKCS#11 support for GnuPG"
HOMEPAGE="http://gnupg-pkcs11.sourceforge.net"
SRC_URI="mirror://sourceforge/gnupg-pkcs11/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="=dev-libs/libassuan-2*
	>=dev-libs/libgcrypt-1.2.2:0
	>=dev-libs/libgpg-error-1.3
	>=dev-libs/openssl-0.9.7
	>=dev-libs/pkcs11-helper-1.02"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	econf --docdir="/usr/share/doc/${PF}"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	prepalldocs
}
