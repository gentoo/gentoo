# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Symfony Cache Component"
HOMEPAGE="https://github.com/symfony/cache"
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> symfony-cache-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
# Test dependencies are not here, mostly because we have to make a live ebuild
# for cache-tag-interop which has no release yet,
# and is needed by cache-integration-tests (also ask for dev-master)
# And there is some package not already in the tree
#
# >=dev-php/cache-integration-tests-9999
# >=dev-php/doctrine-cache-1.6
# >=dev-php/doctrine-dbal-2.4
# >=dev-php/nrk-predis-1.0 )"
RESTRICT="test"

RDEPEND="
	dev-lang/php:*
	dev-php/fedora-autoloader"
DEPEND="
	>=dev-php/psr-cache-1.0
	>=dev-php/psr-log-1.0
	test? (
		${RDEPEND}
		dev-php/phpunit )"

S="${WORKDIR}/cache-${PV}"

src_prepare() {
	default
	if use test; then
		cp "${FILESDIR}"/autoload.php "${S}"/autoload-test.php || die
		sed -i -e "s:__DIR__:__DIR__.'/src':" "${S}"/autoload-test.php || die
		# Some of the dependencies are not packaged yet
		sed -i -e "s:));:\t\$vendorDir . \'/Cache/IntegrationTests/autoload.php\',\n));:" "${S}"/autoload-test.php
		sed -i -e "s:));:\t\$vendorDir . \'/Doctine/Cache/autoload.php\',\n));:" "${S}"/autoload-test.php
		sed -i -e "s:));:\t\$vendorDir . \'/Doctrine/dbal/autoload.php\',\n));:" "${S}"/autoload-test.php
		sed -i -e "s:));:\t\$vendorDir . \'/nrk/predis/autoload.php\',\n));:" "${S}"/autoload-test.php
	fi
}

src_install() {
	insinto "/usr/share/php/Symfony/Component/Cache"
	doins -r Adapter/ Exception/ CacheItem.php DoctrineProvider.php \
	LICENSE "${FILESDIR}"/autoload.php
	dodoc README.md
}

src_test() {
	phpunit --bootstrap "${S}"/autoload-test.php || die "test suite failed"
}
