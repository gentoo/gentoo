# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit php-pear-r2

DESCRIPTION="PHP parser for RDF and RSS documents"
LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="amd64 arm ~hppa ~ia64 ppc ppc64 ~s390 sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-php/PEAR-XML_Parser-1.3.8-r1"
BDEPEND="test? ( ${RDEPEND} dev-php/phpunit )"

PATCHES=( "${FILESDIR}/XML_RSS-1.1.0-php8.patch" )

src_prepare() {
	default
	sed -i \
		-e 's/_Framework_/\\Framework\\/' \
		-e 's/_TextUI_/\\TextUI\\/' \
		tests/*.php
}

src_test() {
	phpunit --bootstrap "${S}/XML/RSS.php" \
		--cache-result-file="${T}/test-results.cache" tests || die
}
