# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="php-code-coverage"

DESCRIPTION="Collection, processing, and rendering for PHP code coverage"
HOMEPAGE="https://phpunit.de"
SRC_URI="https://github.com/sebastianbergmann/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""

S="${WORKDIR}/${MY_PN}-${PV}"

RDEPEND="dev-php/fedora-autoloader
	>=dev-php/File_Iterator-1.4.2
	!>=dev-php/File_Iterator-2.0
	>=dev-php/Text_Template-1.2.1
	!>=dev-php/Text_Template-2.0
	>=dev-php/PHP_TokenStream-2.0.1
	!>=dev-php/PHP_TokenStream-3.0
	>=dev-php/sebastian-environment-3.0
	>=dev-php/sebastian-version-2.0.1
	!>=dev-php/sebastian-version-3.0
	dev-php/sebastian-code-unit-reverse-lookup
	!>=dev-php/sebastian-code-unit-reverse-lookup-2.0
	>=dev-php/theseer-tokenizer-1.1
	>=dev-lang/php-7.0[xml,xmlwriter]"

src_install() {
	insinto /usr/share/php/PHP/CodeCoverage
	doins -r src/*
	doins "${FILESDIR}/autoload.php"
	dodoc README.md
}

pkg_postinst() {
	ewarn "This library now loads via /usr/share/php/PHP/CodeCoverage/autoload.php"
	ewarn "Please update any scripts to require the autoloader"
}
