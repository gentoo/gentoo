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

RDEPEND="
	dev-lang/php:*
	dev-php/fedora-autoloader"
DEPEND="
	>=dev-php/symfony-polyfill-mbstring-1.0
	>=dev-php/symfony-debug-3.0
	test? (
		${RDEPEND}
		dev-php/phpunit
		>=dev-php/symfony-event-dispatcher-3.0
		>=dev-php/symfony-filesystem-3.0
		>=dev-php/symfony-process-3.0
		>=dev-php/psr-log-1.0 )"

S="${WORKDIR}/console-${PV}"

src_prepare() {
	default
	cp "${FILESDIR}"/autoload.php "${S}"/autoload.php || die
	echo "
\$vendorDir = '/usr/share/php';
// Dependencies
\Fedora\Autoloader\Dependencies::required(array(
	\$vendorDir . '/Symfony/Polyfill/Mbstring/autoload.php',
	\$vendorDir . '/Symfony/Component/Debug/autoload.php',
" >> "${S}"/autoload.php || die
	if use test; then
		cp "${S}"/autoload.php "${S}"/autoload-test.php || die
		echo "
	\$vendorDir . '/Symfony/Component/EventDispatcher/autoload.php',
	\$vendorDir . '/Symfony/Component/Filesystem/autoload.php',
	\$vendorDir . '/Symfony/Component/Process/autoload.php',
	\$vendorDir . '/Psr/Log/autoload.php',
));" >> "${S}"/autoload-test.php || die
	fi
	echo "));" >> "${S}"/autoload.php || die
}

src_install() {
	insinto "/usr/share/php/Symfony/Component/Console"
	doins -r Command Descriptor Event Exception Formatter \
	Helper Input Logger Output Question Resources Style \
	Tester Application.php ConsoleEvents.php LICENSE Terminal.php \
	autoload.php
	dodoc README.md
}

src_test() {
	phpunit --bootstrap "${S}"/autoload-test.php || die "test suite failed"
}
