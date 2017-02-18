# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Dependency Manager for PHP"
HOMEPAGE="https://github.com/composer/composer"
SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-lang/php:*[curl]
	>=dev-php/ca-bundle-1.0
	>=dev-php/cli-prompt-1.0
	dev-php/fedora-autoloader
	>=dev-php/json-schema-4.0
	>=dev-php/jsonlint-1.4
	>=dev-php/phar-utils-1.0
	>=dev-php/psr-log-1.0
	>=dev-php/semver-1.0
	>=dev-php/spdx-licenses-1.0
	>=dev-php/symfony-console-3.0
	>=dev-php/symfony-filesystem-3.0
	>=dev-php/symfony-finder-3.0
	>=dev-php/symfony-process-3.0"
DEPEND="
	test? (
		${RDEPEND}
		dev-php/phpunit
		>=dev-php/phpunit-mock-objects-3.0 )"

PATCHES=(
	"${FILESDIR}/${PN}-tests-fix.patch"
)

src_prepare() {
	default
	if use test; then
		cp "${FILESDIR}"/autoload.php "${S}"/src/Composer/autoload.php || die
		sed -i -e "s:));:\t\$vendorDir . \'/phpunit-mock-object/autoload.php\',\n));:" "${S}"/src/Composer/autoload.php
		cp "${FILESDIR}"/bootstrap.php "${S}"/tests/bootstrap.php || die
		rm src/bootstrap.php || die
	fi
}

src_install() {
	eapply "${FILESDIR}/${PN}-update-paths.patch"
	insinto "/usr/share/php/Composer/Composer"
	# Composer expects the LICENSE file to be there, and the
	# easiest thing to do is to give it what it wants.
	doins -r src/Composer/. res LICENSE "${FILESDIR}"/autoload.php
	dobin bin/composer
	dodoc README.md
}

src_test() {
	phpunit || die "test suite failed"
}
