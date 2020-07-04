# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# Upstream now builds against the openssl 1.0.x fork by PeterMosmans
MOSMANS_OPENSSL_COMMIT=c9ba19c8b7fd131137373dbd1fccd6a8bb0628be

inherit eutils toolchain-funcs

DESCRIPTION="Fast SSL configuration scanner"
HOMEPAGE="https://github.com/rbsec/sslscan"
MY_FORK="rbsec"
SRC_URI="https://github.com/${MY_FORK}/${PN}/archive/${PV}-${MY_FORK}.tar.gz -> ${P}-${MY_FORK}.tar.gz
	https://github.com/PeterMosmans/openssl/archive/${MOSMANS_OPENSSL_COMMIT}.tar.gz -> ${P}-${MY_FORK}-openssl.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}-${MY_FORK}"

src_prepare() {
	ln -s ../openssl-${MOSMANS_OPENSSL_COMMIT} openssl || die
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
