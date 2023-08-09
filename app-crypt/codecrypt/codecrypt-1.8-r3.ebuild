# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Post-quantum cryptography tool"
HOMEPAGE="http://e-x-a.org/codecrypt/"
SRC_URI="http://e-x-a.org/codecrypt/files/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="+cryptopp"

DEPEND="
	dev-libs/gmp:=
	sci-libs/fftw:3.0=
	cryptopp? ( >=dev-libs/crypto++-7:= )"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-libcryptopp.pc-rename.patch )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_with cryptopp)
}
