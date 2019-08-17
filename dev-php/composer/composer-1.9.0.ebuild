# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Dependency Manager for PHP"
HOMEPAGE="https://github.com/composer/composer"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-lang/php:*[curl]
	>=dev-php/ca-bundle-1.1.3
	>=dev-php/psr-log-1.1.0
	dev-php/fedora-autoloader
	>=dev-php/json-schema-5.2.7
	>=dev-php/jsonlint-1.7.1
	>=dev-php/phar-utils-1.0.1
	>=dev-php/semver-1.4.2
	>=dev-php/spdx-licenses-1.5.0
	>=dev-php/symfony-console-2.8.48
	>=dev-php/symfony-filesystem-2.8.48
	>=dev-php/symfony-finder-2.8.49
	>=dev-php/symfony-process-2.8.48
	>=dev-php/xdebug-handler-1.3.1"

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
