# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Post-quantum cryptography tool"
HOMEPAGE="http://e-x-a.org/codecrypt/"
SRC_URI="http://e-x-a.org/codecrypt/files/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+cryptopp"

DEPEND="dev-libs/gmp:=
	cryptopp? ( dev-libs/crypto++ )
	sci-libs/fftw:3.0"
RDEPEND="${DEPEND}"

src_prepare() {
	eapply_user
	# workaround -- gentoo is missing crypto++ pkg-config file
	sed -i -e 's/PKG_CHECK_MODULES(\[CRYPTOPP\],.*/LDFLAGS="$LDFLAGS -lcrypto++"/' configure.ac
	./autogen.sh
}

src_configure() {
	econf \
		$(use_with cryptopp )
}
