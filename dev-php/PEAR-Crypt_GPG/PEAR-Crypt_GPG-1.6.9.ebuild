# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN/PEAR-/}"
MY_PV="${PV/_/}"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="PHP interface to the GNU Privacy Guard (GnuPG)"
HOMEPAGE="https://pear.php.net/package/Crypt_GPG"
SRC_URI="https://download.pear.php.net/package/${MY_P}.tgz"
S="${WORKDIR}/${MY_P}"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc64 ~sparc ~x86"

RDEPEND="app-crypt/gnupg
	dev-lang/php:*[posix(-),unicode(-)]
	dev-php/PEAR-Console_CommandLine
	dev-php/PEAR-Exception"

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
