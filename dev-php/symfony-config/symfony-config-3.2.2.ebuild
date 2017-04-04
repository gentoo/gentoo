# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Symfony Config Component"
HOMEPAGE="https://github.com/symfony/config"
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> symfony-config-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="test"

RDEPEND="
	dev-lang/php:*
	dev-php/fedora-autoloader
	>=dev-php/symfony-filesystem-3.0"
DEPEND="
	test? (
		${RDEPEND}
		dev-php/phpunit
		>=dev-php/symfony-yaml-3.0 )"

S="${WORKDIR}/config-${PV}"

src_prepare() {
	default
	if use test; then
		cp "${FILESDIR}"/autoload.php "${S}"/autoload-test.php || die
		sed -i -e "s:__DIR__:__DIR__.'/src':" "${S}"/autoload-test.php || die
		sed -i -e "s:));:\t\$vendorDir . \'/Symfony/Component/Yaml/autoload.php\',\n));:" "${S}"/autoload-test.php
	fi
}

src_install() {
	insinto "/usr/share/php/Symfony/Component/Config"
	doins -r Definition Exception Loader Resource \
	Util ConfigCacheFactoryInterface.php ConfigCacheFactory.php \
	ConfigCacheInterface.php ConfigCache.php FileLocatorInterface.php \
	FileLocator.php LICENSE ResourceCheckerConfigCacheFactory.php \
	ResourceCheckerConfigCache.php ResourceCheckerInterface.php \
	"${FILESDIR}"/autoload.php
	dodoc README.md
}

src_test() {
	phpunit --bootstrap "${S}"/autoload-test.php || die "test suite failed"
}
