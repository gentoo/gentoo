# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

OPENSSL_V=1.0.2k

inherit eutils toolchain-funcs

DESCRIPTION="Fast SSL configuration scanner"
HOMEPAGE="https://github.com/rbsec/sslscan"
MY_FORK="rbsec"
SRC_URI="https://github.com/${MY_FORK}/${PN}/archive/${PV}-${MY_FORK}.tar.gz -> ${P}-${MY_FORK}.tar.gz
	static? ( mirror://openssl/source/openssl-${OPENSSL_V}.tar.gz )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libressl +static"

# Depend on -bindist since sslscan unconditionally requires elliptic
# curve support, bug 491102
DEPEND="!libressl? ( dev-libs/openssl:0[-bindist] ) libressl? ( dev-libs/libressl )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}-${MY_FORK}"

src_prepare() {
	if use static; then
		ln -s ../openssl-${OPENSSL_V} openssl || die
		touch .openssl_is_fresh || die

		sed -i -e '/openssl\/.git/,/fi/d' \
			-e '/openssl test/d' Makefile || die

	fi

	default
}

src_compile() {
	if use static; then
		emake static
	else
		emake
	fi
}

src_install() {
	DESTDIR="${D}" emake install

	dodoc Changelog README.md
}
