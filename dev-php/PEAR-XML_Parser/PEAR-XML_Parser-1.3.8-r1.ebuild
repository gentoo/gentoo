# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit php-pear-r2

DESCRIPTION="XML parsing class based on PHP's SAX parser"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm ~hppa ppc64 ~s390 sparc x86"
IUSE=""
# This is to match patch compatibility
RDEPEND="!<dev-php/PEAR-XML_RSS-1.1.0-r2"

PATCHES=( "${FILESDIR}/XML_Parser-1.3.8-php8.patch" )

src_test() {
	peardev run-tests -r || die
}

pkg_postinst() {
	php-pear-r2_pkg_postinst
	elog 'This version includes a PHP 8 compatibilty patch for startHandler'
	elog 'which removes the pass-by-reference off of $attribs (third parameter).'
	elog 'This could break old scripts with recent versions until that override also'
	elog 'removes the pass-by-reference.'
}
