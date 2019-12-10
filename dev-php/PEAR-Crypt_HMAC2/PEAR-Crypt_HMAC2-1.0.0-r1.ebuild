# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit php-pear-r2

DESCRIPTION="Implementation of Hashed Message Authentication Code for PHP5"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"
DEPEND="test? ( dev-php/PEAR-PEAR dev-php/phpunit )"
HTML_DOCS=( docs/intro.xml )

src_test() {
	phpunit tests || die
}

pkg_postinst() {
	if ! has_version "dev-lang/php[hash]" ; then
		elog "${PN} can use the hash extension when enabled to extend the range"
		elog "of cryptographic hash functions beyond the natively implemented MD5 and SHA1."
		elog "Recompile dev-lang/php with USE=\"hash\" if you want these features."
	fi
}
