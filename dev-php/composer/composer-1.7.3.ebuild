# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Dependency Manager for PHP"
HOMEPAGE="https://github.com/composer/composer"
SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-lang/php:*[curl]
	>=dev-php/ca-bundle-1.1.2
	>=dev-php/psr-log-1.0.2
	dev-php/fedora-autoloader
	>=dev-php/json-schema-5.2.7
	>=dev-php/jsonlint-1.7.1
	>=dev-php/phar-utils-1.0.1
	>=dev-php/semver-1.4.2
	>=dev-php/spdx-licenses-1.4.0
	>=dev-php/symfony-console-2.8.43
	>=dev-php/symfony-filesystem-2.8.43
	>=dev-php/symfony-finder-2.7.20
	>=dev-php/symfony-process-2.8.43
	>=dev-php/xdebug-handler-1.2.0"

src_install() {
	insinto "/usr/share/${PN}"

	# Composer expects the LICENSE file to be there, and the
	# easiest thing to do is to give it what it wants.
	doins -r src res LICENSE

	insinto "/usr/share/${PN}/vendor"
	newins "${FILESDIR}"/autoload-r1.php autoload.php

	exeinto "/usr/share/${PN}/bin"
	doexe "bin/${PN}"
	dosym "../share/${PN}/bin/${PN}" "/usr/bin/${PN}"

	dodoc CHANGELOG.md README.md doc/*.md
	dodoc -r doc/articles doc/faqs
}
