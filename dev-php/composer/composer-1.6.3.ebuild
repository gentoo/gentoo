# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Dependency Manager for PHP"
HOMEPAGE="https://github.com/composer/composer"
SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-lang/php:*[curl]
	>=dev-php/ca-bundle-1.0.0
	>=dev-php/cli-prompt-1.0.0
	>=dev-php/psr-log-1.0.2
	dev-php/fedora-autoloader
	>=dev-php/json-schema-3.0.0
	>=dev-php/jsonlint-1.4.0
	>=dev-php/phar-utils-1.0.0
	>=dev-php/semver-1.0.0
	>=dev-php/spdx-licenses-1.2.0
	>=dev-php/symfony-console-2.7.9
	>=dev-php/symfony-filesystem-2.7.20
	>=dev-php/symfony-finder-2.7.20
	>=dev-php/symfony-process-2.8.12"

src_install() {
	insinto "/usr/share/${PN}"

	# Composer expects the LICENSE file to be there, and the
	# easiest thing to do is to give it what it wants.
	doins -r src res LICENSE

	insinto "/usr/share/${PN}/vendor"
	doins "${FILESDIR}"/autoload.php

	exeinto "/usr/share/${PN}/bin"
	doexe "bin/${PN}"
	dosym "../share/${PN}/bin/${PN}" "/usr/bin/${PN}"

	dodoc CHANGELOG.md README.md doc/*.md
	dodoc -r doc/articles doc/faqs
}
