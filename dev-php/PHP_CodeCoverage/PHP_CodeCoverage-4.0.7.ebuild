# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="php-code-coverage"

DESCRIPTION="Collection, processing, and rendering for PHP code coverage"
HOMEPAGE="http://phpunit.de"
SRC_URI="https://github.com/sebastianbergmann/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86"
IUSE=""

S="${WORKDIR}/${MY_PN}-${PV}"

RDEPEND="dev-php/fedora-autoloader
	>=dev-php/File_Iterator-1.3
	!>=dev-php/File_Iterator-2.0
	>=dev-php/Text_Template-1.2
	!>=dev-php/Text_Template-2.0
	>=dev-php/PHP_TokenStream-1.4
	!>=dev-php/PHP_TokenStream-3.0
	>=dev-php/sebastian-environment-1.3.2
	!>=dev-php/sebastian-environment-3.0
	>=dev-php/sebastian-version-1.0
	!>=dev-php/sebastian-version-3.0
	dev-php/sebastian-code-unit-reverse-lookup
	!>=dev-php/sebastian-code-unit-reverse-lookup-2.0
	|| (
		dev-lang/php:5.6[xml,xmlwriter]
		dev-lang/php:7.0[xml,xmlwriter]
		dev-lang/php:7.1[xml,xmlwriter]
	)"

src_install() {
	insinto /usr/share/php/PHP/CodeCoverage
	doins -r src/*
	doins "${FILESDIR}/autoload.php"
}

pkg_postinst() {
	ewarn "This library now loads via /usr/share/php/PHP/CodeCoverage/autoload.php"
	ewarn "Please update any scripts to require the autoloader"
}
