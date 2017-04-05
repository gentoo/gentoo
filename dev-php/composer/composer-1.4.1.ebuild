# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Dependency Manager for PHP"
HOMEPAGE="https://github.com/composer/composer"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-lang/php:*[curl]
	dev-php/fedora-autoloader
	>=dev-php/json-schema-3.0
	>=dev-php/ca-bundle-1.0
	>=dev-php/semver-1.0
	>=dev-php/spdx-licenses-1.0
	>=dev-php/jsonlint-1.4
	>=dev-php/symfony-console-2.7
	>=dev-php/symfony-finder-2.7
	>=dev-php/symfony-process-2.7
	>=dev-php/symfony-filesystem-2.7
	>=dev-php/phar-utils-1.0
	>=dev-php/cli-prompt-1.0
	>=dev-php/psr-log-1.0"

PATCHES=(
	"${FILESDIR}/${PN}-update-paths.patch"
)

src_install() {
	insinto "/usr/share/php/Composer/Composer"

	# Composer expects the LICENSE file to be there, and the
	# easiest thing to do is to give it what it wants.
	doins -r src/Composer/. res LICENSE "${FILESDIR}"/autoload.php
	dobin bin/composer
	dodoc README.md
}
