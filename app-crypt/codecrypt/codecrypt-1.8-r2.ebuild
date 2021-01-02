# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Post-quantum cryptography tool"
HOMEPAGE="http://e-x-a.org/codecrypt/"
SRC_URI="http://e-x-a.org/codecrypt/files/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="+cryptopp"

DEPEND="dev-libs/gmp:=
	cryptopp? ( >=dev-libs/crypto++-7:= )
	sci-libs/fftw:3.0="
RDEPEND="${DEPEND}"
src_prepare() {
	default
	# workaround -- the library renamed the pkg-config file
	sed -i -e 's/PKG_CHECK_MODULES(\[CRYPTOPP\],.*/PKG_CHECK_MODULES([CRYPTOPP], [libcryptopp])/' configure.ac || die
	eautoreconf
}

src_configure() {
	econf \
		$(use_with cryptopp )
}
