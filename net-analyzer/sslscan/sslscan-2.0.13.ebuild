# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# sslscan builds against a static openssl library to allow weak ciphers
# to be enabled so that they can be tested.
OPENSSL_RELEASE_TAG="OpenSSL_1_1_1n"

DESCRIPTION="Fast SSL configuration scanner"
HOMEPAGE="https://github.com/rbsec/sslscan"
SRC_URI="https://github.com/rbsec/sslscan/archive/${PV}.tar.gz -> ${P}.tar.gz
		 https://github.com/openssl/openssl/archive/${OPENSSL_RELEASE_TAG}.tar.gz -> ${PN}-${OPENSSL_RELEASE_TAG}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# Requires a docker environment
RESTRICT="test"

# S="${WORKDIR}/${P}-${MY_FORK}"

src_prepare() {
	ln -s ../openssl-${OPENSSL_RELEASE_TAG} openssl || die
	touch .openssl_is_fresh || die
	sed -i -e '/openssl\/.git/,/fi/d' \
		-e '/openssl test/d' Makefile || die

	default
}

src_compile() {
	emake static
}

src_install() {
	DESTDIR="${D}" emake install

	dodoc Changelog README.md
}
