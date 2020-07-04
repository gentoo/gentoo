# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Symfony EventDispatcher Component"
HOMEPAGE="https://github.com/symfony/event-dispatcher"
SRC_URI="https://github.com/symfony/event-dispatcher/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-lang/php:*
	dev-php/fedora-autoloader
	>=dev-php/symfony-dependency-injection-2.1.0"
DEPEND="
	test? (
		${RDEPEND}
		dev-php/phpunit )"

S="${WORKDIR}/event-dispatcher-${PV}"

src_prepare() {
	default
	if use test; then
		cp "${FILESDIR}"/autoload.php "${S}"/autoload-test.php || die
	fi
}

src_install() {
	insinto "/usr/share/php/Symfony/Component/EventDispatcher"
	doins -r . "${FILESDIR}"/autoload.php
	dodoc README.md
}

src_test() {
	phpunit --bootstrap "${S}"/autoload-test.php || die "test suite failed"
}
