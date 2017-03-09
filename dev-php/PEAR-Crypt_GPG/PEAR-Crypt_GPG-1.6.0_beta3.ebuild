# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="${PN/PEAR-/}"
MY_PV="${PV/_/}"
MY_PV="${MY_PV/beta/b}"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="PHP interface to the GNU Privacy Guard (GnuPG)"
HOMEPAGE="http://pear.php.net/package/${MY_PN}"
SRC_URI="http://download.pear.php.net/package/${MY_P}.tgz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="test"

# Really only needs PEAR_Exception, not PEAR-PEAR.
RDEPEND="app-crypt/gnupg
	dev-lang/php:*[posix,unicode]
	dev-php/PEAR-Console_CommandLine
	dev-php/PEAR-PEAR"
DEPEND="test? (	${RDEPEND} dev-php/phpunit )"

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
