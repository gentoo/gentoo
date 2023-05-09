# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

DESCRIPTION="Dependency Manager for PHP"
HOMEPAGE="https://github.com/composer/composer"
SRC_URI="https://github.com/composer/composer/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

BDEPEND="dev-php/theseer-Autoload"

RDEPEND="dev-lang/php:*[curl]
	>=dev-php/ca-bundle-1.0
	>=dev-php/class-map-generator-1.0
	>=dev-php/metadata-minifier-1.0
	>=dev-php/pcre-2.1
	>=dev-php/semver-3.0
	>=dev-php/spdx-licenses-1.5
	>=dev-php/xdebug-handler-2
	>=dev-php/json-schema-5.2.11
	>=dev-php/psr-log-1.0
	>=dev-php/jsonlint-1.4
	>=dev-php/phar-utils-1.2
	>=dev-php/symfony-console-5.4.11
	>=dev-php/symfony-filesystem-5.4
	>=dev-php/symfony-finder-5.4
	>=dev-php/symfony-process-5.4
	>=dev-php/reactphp-promise-2.8
	>=dev-php/symfony-polyfill-php80-1.24
	>=dev-php/symfony-polyfill-php81-1.24
	>=dev-php/signal-handler-2
	dev-php/fedora-autoloader"

# dependency to >=dev-php/symfony-polyfill-php73-1.24 dropped, because PHP 7.3 is not longer in portage

PATCHES=(
	"${FILESDIR}"/autoload.patch
)

src_prepare() {
	default

	mkdir vendor || die

	phpab \
		--quiet \
		--output vendor/autoload.php \
		--template "${FILESDIR}"/autoload.php.tpl \
		--basedir src \
		src \
		|| die

	cat >> vendor/autoload.php <<EOF || die "failed to extend autoload.php"

// Dependencies
\Fedora\Autoloader\Dependencies::required([
	'/usr/share/php/Composer/CaBundle/autoload.php',
	'/usr/share/php/Composer/ClassMapGenerator/autoload.php',
	'/usr/share/php/Composer/MetadataMinifier/autoload.php',
	'/usr/share/php/Composer/Pcre/autoload.php',
	'/usr/share/php/Composer/Semver/autoload.php',
	'/usr/share/php/Composer/XdebugHandler/autoload.php',
	'/usr/share/php/Composer/Spdx/autoload.php',
	'/usr/share/php/TheSeer/Autoload/autoload.php',
	'/usr/share/php/TheSeer/DirectoryScanner/autoload.php',
	'/usr/share/php/Psr/Log/autoload.php',
	'/usr/share/php/Seld/PharUtils/autoload.php',
	'/usr/share/php/Seld/JsonLint/autoload.php',
	'/usr/share/php/Seld/SignalHandler/autoload.php',
	'/usr/share/php/Fedora/Autoloader/autoload.php',
	'/usr/share/php/JsonSchema/autoload.php',
	'/usr/share/php/React/Promise/autoload.php',
	'/usr/share/php/Symfony/Component/PolyfillCtype/autoload.php',
	'/usr/share/php/Symfony/Component/DeprecationContracts/autoload.php',
	'/usr/share/php/Symfony/Component/ServiceContracts/autoload.php',
	'/usr/share/php/Symfony/Component/PolyfillIntlNormalizer/autoload.php',
	'/usr/share/php/Symfony/Component/Filesystem/autoload.php',
	'/usr/share/php/Symfony/Component/Finder/autoload.php',
	'/usr/share/php/Symfony/Component/Console/autoload.php',
	'/usr/share/php/Symfony/Component/PolyfillMbstring/autoload.php',
	'/usr/share/php/Symfony/Component/Process/autoload.php',
	'/usr/share/php/Symfony/Component/PolyfillIntlGrapheme/autoload.php',
	'/usr/share/php/Symfony/Component/Polyfill-php80/autoload.php',
	'/usr/share/php/Symfony/Component/Polyfill-php81/autoload.php',
	'/usr/share/php/Symfony/Component/String/autoload.php',
]);
EOF
}

src_install() {
	insinto "/usr/share/${PN}"

	# Composer expects the LICENSE file to be there, and the
	# easiest thing to do is to give it what it wants.
	doins -r LICENSE res src vendor

	exeinto "/usr/share/${PN}/bin"
	doexe "bin/${PN}"
	dosym "../share/${PN}/bin/${PN}" "/usr/bin/${PN}"

	dodoc CHANGELOG.md README.md doc/*.md
	dodoc -r doc/articles doc/faqs
}
