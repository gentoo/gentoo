# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
inherit php-pear-r2

DESCRIPTION="Class for multilingual applications management"
LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"
IUSE="examples minimal xml"

RDEPEND="dev-lang/php:*[nls]
	!minimal? ( dev-php/PEAR-Cache_Lite
			dev-php/PEAR-DB
			dev-php/PEAR-DB_DataObject
			dev-php/PEAR-MDB
			dev-php/PEAR-MDB2
			dev-php/PEAR-File_Gettext
			>=dev-php/PEAR-I18Nv2-0.9.1 )
	xml? ( >=dev-php/PEAR-XML_Serializer-0.13.0 )"
PATCHES=( "${FILESDIR}/modern-php.patch" )
src_install() {
	local DOCS=( docs/gettext_readme.txt )
	php-pear-r2_src_install
	use examples && dodoc -r docs/examples
	# Fix this for PHP5
	# dobin scripts/t2xmlchk.php
}
