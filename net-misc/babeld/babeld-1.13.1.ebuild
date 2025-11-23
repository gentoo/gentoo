# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

BLAKE2_COMMIT=320c325437539ae91091ce62efec1913cd8093c2
RFC6234_COMMIT=285c8b86c0c6b8e9ffe1c420c5b09fa229629a30

DESCRIPTION="a loop-free distance-vector routing protocol"
HOMEPAGE="https://github.com/jech/babeld"
SRC_URI="
	https://github.com/jech/babeld/archive/${P}.tar.gz
	https://github.com/BLAKE2/BLAKE2/archive/${BLAKE2_COMMIT}.tar.gz
		-> ${PN}-BLAKE2-${BLAKE2_COMMIT}.tar.gz
	https://github.com/massar/rfc6234/archive/${RFC6234_COMMIT}.tar.gz
		-> ${PN}-rfc6234-${RFC6234_COMMIT}.tar.gz
"
S=${WORKDIR}/${PN}-${P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_unpack() {
	default
	cd "${S}"
	rm -r BLAKE2 rfc6234 || die
	ln -s ../BLAKE2-${BLAKE2_COMMIT} BLAKE2 || die
	ln -s ../rfc6234-${RFC6234_COMMIT} rfc6234 || die
}

src_compile() {
	emake CDEBUGFLAGS="${CFLAGS}"
}

src_install() {
	emake TARGET="${ED}" PREFIX="/usr" install
	dodoc CHANGES README
	doinitd "${FILESDIR}"/${PN}
}
