# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Subtree split of the Symfony Console Component"
HOMEPAGE="https://github.com/symfony/console"
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
		>=dev-php/psr-log-1.0.2
		>=dev-php/symfony-event-dispatcher-2.1.0
		>=dev-php/symfony-process-2.8.12 )"

S="${WORKDIR}/console-${PV}"

src_prepare() {
	default
	if use test; then
		cp "${FILESDIR}"/autoload.php "${S}"/autoload-test.php || die
		echo "
\$vendorDir = '/usr/share/php';
// Dependencies
\Fedora\Autoloader\Dependencies::required(array(
	\$vendorDir . '/Symfony/Component/EventDispatcher/autoload.php',
	\$vendorDir . '/Psr/Log/autoload.php',
	\$vendorDir . '/Symfony/Component/Process/autoload.php',
));" >> "${S}"/autoload-test.php || die
	fi
}

src_install() {
	insinto "/usr/share/php/Symfony/Component/Console"
	doins -r Command Descriptor Event Formatter Helper \
	Input Logger Output Question Resources Style Tester \
	Application.php ConsoleEvents.php LICENSE Shell.php \
	"${FILESDIR}"/autoload.php
	dodoc README.md
}

src_test() {
	phpunit --bootstrap "${S}"/autoload-test.php || die "test suite failed"
}
