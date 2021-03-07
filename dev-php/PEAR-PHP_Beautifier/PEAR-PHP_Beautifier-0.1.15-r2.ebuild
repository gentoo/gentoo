# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="${PN/PEAR-/}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Code Beautifier for PHP"
HOMEPAGE="https://pear.php.net/package/PHP_Beautifier"
SRC_URI="http://download.pear.php.net/package/${MY_P}.tgz"
LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cli examples"

# Require automagic dependencies unconditionally to avoid surprises.
RDEPEND="dev-lang/php:*[bzip2,cli?,tokenizer]
	dev-php/PEAR-Archive_Tar
	dev-php/PEAR-Log
	dev-php/PEAR-PEAR
	cli? ( dev-php/PEAR-Console_Getopt )"

S="${WORKDIR}/${MY_P}"

PATCHES=( "${FILESDIR}/use_default_error_reporting.patch" )

src_prepare() {
	default
	shopt -s globstar
	for file in scripts/php_beautifier **/*.php; do
		sed -i "s|@package_version@|${PV}|g" "${file}" || die
		sed -i "s|@php_bin@|${EPREFIX}/usr/bin/php|g" "${file}" || die
	done
	shopt -u globstar
}

src_install() {
	insinto /usr/share/php/PHP
	doins Beautifier.php
	doins -r Beautifier
	use examples && dodoc -r examples
	use cli && dobin scripts/php_beautifier
}
