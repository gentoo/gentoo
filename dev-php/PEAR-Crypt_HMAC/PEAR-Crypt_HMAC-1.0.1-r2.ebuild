# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit php-pear-r2

DESCRIPTION="Calculates RFC 2104 compliant hashes"
LICENSE="PHP-3"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"
DEPEND="test? ( dev-php/PEAR-PEAR )"
PATCHES=( "${FILESDIR}/HMAC-1.0.1.patch" )

src_test() {
	ln -s . Crypt || die
	peardev run-tests tests || die
}

src_install() {
	insinto /usr/share/php/Crypt
	doins HMAC.php
	php-pear-r2_install_packagexml
}
