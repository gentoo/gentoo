# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN/PEAR-/}"
MY_PV="${PV/_/}"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="PHP interface to the GNU Privacy Guard (GnuPG)"
HOMEPAGE="https://pear.php.net/package/${MY_PN}"
SRC_URI="http://download.pear.php.net/package/${MY_P}.tgz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="app-crypt/gnupg
	dev-lang/php:*[posix,unicode]
	dev-php/PEAR-Console_CommandLine
	dev-php/PEAR-Exception"
BDEPEND="test? ( ${RDEPEND} dev-php/phpunit )"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	sed -i "s|@bin-dir@|${EPREFIX}/usr/bin|" Crypt/GPG/Engine.php || die
	sed -i "s|@package-name@|${MY_PN}|" Crypt/GPG/PinEntry.php || die
	sed -i "s|@data-dir@|${EPREFIX}/usr/share|" Crypt/GPG/PinEntry.php || die
}

src_install() {
	dodoc README.md
	dobin scripts/crypt-gpg-pinentry

	insinto "/usr/share/${MY_PN}"
	doins -r data

	insinto /usr/share/php
	doins -r Crypt
}

src_test() {
	phpunit tests/ || die "test suite failed"
}
