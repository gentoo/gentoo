# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Symfony YAML Component"
HOMEPAGE="https://github.com/symfony/yaml"
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="test"

RDEPEND="
	dev-lang/php:*
	dev-php/fedora-autoloader"
DEPEND="
	test? (
		${RDEPEND}
		dev-php/phpunit
		>=dev-php/symfony-console-3.0 )"

S="${WORKDIR}/yaml-${PV}"

src_prepare() {
	default
	if use test; then
		cp "${FILESDIR}"/autoload.php "${S}"/autoload-test.php || die
		echo "
\$vendorDir = '/usr/share/php';
// Dependencies
\Fedora\Autoloader\Dependencies::required(array(
	\$vendorDir . '/Symfony/Component/Console/autoload.php',
));" >> "${S}"/autoload-test.php || die
	fi
}

src_install() {
	insinto "/usr/share/php/Symfony/Component/Yaml"
	doins -r Command/ Exception/ Dumper.php Escaper.php \
	Inline.php LICENSE Parser.php Unescaper.php Yaml.php \
	"${FILESDIR}"/autoload.php
	dodoc README.md
}

src_test() {
	phpunit --bootstrap "${S}"/autoload-test.php || die "test suite failed"
}
