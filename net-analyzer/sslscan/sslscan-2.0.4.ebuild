# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# sslscan builds against a static openssl library to allow weak ciphers
# to be enabled so that they can be tested.
OPENSSL_RELEASE_TAG="OpenSSL_1_1_1h"

inherit toolchain-funcs

DESCRIPTION="Fast SSL configuration scanner"
HOMEPAGE="https://github.com/rbsec/sslscan"
#MY_FORK="rbsec"
#SRC_URI="https://github.com/${MY_FORK}/${PN}/archive/${PV}-${MY_FORK}.tar.gz -> ${P}-${MY_FORK}.tar.gz
#	https://github.com/PeterMosmans/openssl/archive/${MOSMANS_OPENSSL_COMMIT}.tar.gz -> ${P}-${MY_FORK}-openssl.tar.gz"
SRC_URI="https://github.com/rbsec/sslscan/archive/${PV}.tar.gz -> ${P}.tar.gz
		 https://github.com/openssl/openssl/archive/${OPENSSL_RELEASE_TAG}.tar.gz -> ${PN}-${OPENSSL_RELEASE_TAG}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

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
