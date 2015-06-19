# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/codecrypt/codecrypt-1.4.1.ebuild,v 1.1 2014/01/25 17:18:28 yac Exp $

EAPI=5

DESCRIPTION="Post-quantum cryptography tool"
HOMEPAGE="http://e-x-a.org/codecrypt/"
SRC_URI="http://e-x-a.org/codecrypt/files/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+cryptopp"

DEPEND="dev-libs/gmp
	cryptopp? ( dev-libs/crypto++ )"
RDEPEND="${DEPEND}"

src_configure() {
	econf \
		$(use_with cryptopp)
}
