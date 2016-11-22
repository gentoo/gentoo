# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils toolchain-funcs multilib

COMMIT_ID=7b13512edbd77c35d20edb4e53d5d83eeaf05d52

DESCRIPTION="AF_ALG for OpenSSL"
HOMEPAGE="http://carnivore.it/2011/04/23/openssl_-_af_alg"

MY_P="$PN-${COMMIT_ID}"
SRC_URI="http://src.carnivore.it/users/common/af_alg/snapshot/${MY_P}.tar.gz"

LICENSE="openssl"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libressl"

DEPEND="!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_compile() {
	$(tc-getCC) ${CFLAGS} ${CPPFLAGS} ${LDFLAGS} -Wall -fPIC \
		-shared -Wl,-soname,libaf_alg.so -lcrypto -o libaf_alg.so \
		e_af_alg.c
}

src_install() {
	exeinto /usr/$(get_libdir)/engines
	doexe libaf_alg.so
	dodoc README
}
