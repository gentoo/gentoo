# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Symfony Debug Component"
HOMEPAGE="https://github.com/symfony/debug"
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
# Test suite need packages not already in the tree
# dev-php/symfony-class-loader-3.0
# dev-php/symfony-http-kernel-3.0
RESTRICT="test"

RDEPEND="
	dev-lang/php:*
	dev-php/fedora-autoloader
	>=dev-php/psr-log-1.0"
DEPEND="
	test? (
		${RDEPEND}
		dev-php/phpunit )"

S="${WORKDIR}/debug-${PV}"

src_prepare() {
	default
	if use test; then
		cp "${FILESDIR}"/autoload.php "${S}"/autoload-test.php || die
	fi
}

src_install() {
	insinto "/usr/share/php/Symfony/Component/Debug"
	doins -r Exception Resources  BufferingLogger.php Debug.php \
	ExceptionHandler.php phpunit.xml.dist FatalErrorHandler Tests \
	DebugClassLoader.php ErrorHandler.php "${FILESDIR}"/autoload.php
	dodoc README.md
}

src_test() {
	phpunit --bootstrap "${S}"/autoload-test.php || die "test suite failed"
}
