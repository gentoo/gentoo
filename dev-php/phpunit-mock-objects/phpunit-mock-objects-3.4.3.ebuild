# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Mock Object library for PHPUnit"
HOMEPAGE="https://phpunit.de"
SRC_URI="https://github.com/sebastianbergmann/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ~ia64 ppc ppc64 ~s390 sparc x86"
IUSE=""

RDEPEND="dev-php/fedora-autoloader
	>=dev-php/Text_Template-1.2
	!>=dev-php/Text_Template-2.0
	<dev-php/doctrine-instantiator-2.0
	<dev-php/sebastian-exporter-3.0
	!<dev-php/phpunit-5.4.0
	>=dev-lang/php-5.6:*"

src_install() {
	insinto /usr/share/php/PHPUnit/
	doins -r src/*
	insinto /usr/share/php/PHPUnit/Framework/MockObject
	doins "${FILESDIR}/autoload.php"
}
