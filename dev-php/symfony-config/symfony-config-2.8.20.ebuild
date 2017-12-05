# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Symfony Config Component"
HOMEPAGE="https://github.com/symfony/config"
SRC_URI="https://github.com/symfony/config/archive/v${PV}.tar.gz
	-> symfony-config-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-lang/php:*
	dev-php/fedora-autoloader
	dev-php/symfony-filesystem"
DEPEND="test? (	${RDEPEND} >=dev-php/phpunit-5.7.15 )"

S="${WORKDIR}/config-${PV}"

src_prepare() {
	default
	if use test; then
		cp "${FILESDIR}"/autoload.php "${S}"/autoload-test.php || die
	fi
}

src_install() {
	insinto "/usr/share/php/Symfony/Component/Config"
	doins -r . "${FILESDIR}"/autoload.php
	dodoc README.md
}

src_test() {
	phpunit --bootstrap "${S}/autoload-test.php" || die 'test suite failed'
}
