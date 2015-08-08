# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit flag-o-matic toolchain-funcs multilib-minimal

DESCRIPTION="high-speed software library for network communication, encryption, decryption, signatures"
HOMEPAGE="http://nacl.cr.yp.to/"
SRC_URI="http://hyperelliptic.org/nacl/${P/0_p}.tar.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND=""
RDEPEND="${DEPEND}"

S=${WORKDIR}/${P/0_p}

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/nacl/cpucycles.h
	/usr/include/nacl/crypto_core_hsalsa20.h
	/usr/include/nacl/crypto_hashblocks_sha256.h
	/usr/include/nacl/crypto_hashblocks_sha512.h
	/usr/include/nacl/crypto_onetimeauth_poly1305.h
	/usr/include/nacl/crypto_scalarmult_curve25519.h
	/usr/include/nacl/crypto_stream_aes128ctr.h
	/usr/include/nacl/crypto_stream_salsa20.h
	/usr/include/nacl/crypto_stream_salsa2012.h
	/usr/include/nacl/crypto_stream_salsa208.h )

src_prepare() {
	#drop useless path elements, verbose output, predictable include dir
	sed -e '/^export/d' \
		-e '/^PATH/d' \
		-e '/^LD_LIBRARY_PATH/d' \
		-e '/^DYLD_LIBRARY_PATH/d' \
		-e '/^exec >/d' \
		-e '/^shorthostname/s:=.*:=gentoo:' \
		-i do || die
	sed -e 's:=== `date` === ::' \
		-i $(find . -name do) || die
	rm -r tests

	multilib_copy_sources

	filter-flags "-O*"
	append-cflags -O3 -fomit-frame-pointer -funroll-loops
	append-cxxflags -O3 -fomit-frame-pointer -funroll-loops
}

multilib_src_configure() {
	echo "$(tc-getCC) ${CFLAGS}" > okcompilers/c
	echo "$(tc-getCXX) ${CXXFLAGS}" > okcompilers/cpp
	echo "$(tc-getAR)" > okcompilers/archivers

	sed -e "1aexport PATH=\"${BUILD_DIR}/build/gentoo/bin:${PATH}\"" \
		-i do || die
}

multilib_src_compile() {
	./do || die
}

multilib_src_install() {
	insinto /usr/$(get_libdir)/${PN}
	doins build/gentoo/lib/*/*

	insinto /usr/include/${PN}
	doins build/gentoo/include/*/*
}
