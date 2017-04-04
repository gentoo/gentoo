# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Symfony EventDispatcher Component"
HOMEPAGE="https://github.com/symfony/event-dispatcher"
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-lang/php:*
	dev-php/fedora-autoloader"
DEPEND="
	test? (
		${RDEPEND}
		dev-php/phpunit
		>=dev-php/symfony-dependency-injection-3.0
		>=dev-php/symfony-expression-language-3.0
		>=dev-php/symfony-config-3.0
		>=dev-php/symfony-stopwatch-3.0
		>=dev-php/psr-log-1.0
		)"

S="${WORKDIR}/event-dispatcher-${PV}"

src_prepare() {
	default
	if use test; then
		cp "${FILESDIR}"/autoload.php "${S}"/autoload-test.php || die
		echo "
\$vendorDir = '/usr/share/php';
// Dependencies
\Fedora\Autoloader\Dependencies::required(array(
	\$vendorDir . '/Symfony/Component/DependencyInjection/autoload.php',
	\$vendorDir . '/Symfony/Component/ExpressionLanguage/autoload.php',
	\$vendorDir . '/Symfony/Component/Config/autoload.php',
	\$vendorDir . '/Symfony/Component/Stopwatch/autoload.php',
	\$vendorDir . '/Psr/Log/autoload.php',
));" >> "${S}"/autoload-test.php || die
	fi
}

src_install() {
	insinto "/usr/share/php/Symfony/Component/EventDispatcher"
	doins -r Debug DependencyInjection ContainerAwareEventDispatcher.php \
	EventDispatcherInterface.php EventDispatcher.php Event.php \
	EventSubscriberInterface.php GenericEvent.php \
	ImmutableEventDispatcher.php  "${FILESDIR}"/autoload.php
	dodoc README.md
}

src_test() {
	phpunit --bootstrap "${S}"/autoload-test.php || die "test suite failed"
}
