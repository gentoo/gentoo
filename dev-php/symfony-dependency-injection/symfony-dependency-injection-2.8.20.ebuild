# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Symfony DependencyInjection Component"
HOMEPAGE="https://github.com/symfony/dependency-injection"
SRC_URI="https://github.com/symfony/dependency-injection/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

# The test suite requires the unpackaged symfony-expression-language.
RESTRICT=test

# I'm not sure if symfony-config and symfony-yaml are actually needed if
# you're not running the test suite...
RDEPEND="dev-lang/php:*
	dev-php/fedora-autoloader
	>=dev-php/symfony-config-2.1.0
	>=dev-php/symfony-yaml-2.1.0"
DEPEND="test? ( ${RDEPEND} >=dev-php/phpunit-5.7.15 )"

S="${WORKDIR}/dependency-injection-${PV}"

src_prepare() {
	default
	if use test; then
		cp "${FILESDIR}/autoload.php" "${S}/autoload-test.php" || die
	fi
}

src_install() {
	insinto "/usr/share/php/Symfony/Component/DependencyInjection"
	doins -r Compiler Dumper Exception Extension LazyProxy Loader ParameterBag
	doins *.php "${FILESDIR}/autoload.php"
	dodoc CHANGELOG.md README.md
}

src_test() {
	phpunit --bootstrap "${S}/autoload-test.php" || die 'test suite failed'
}
