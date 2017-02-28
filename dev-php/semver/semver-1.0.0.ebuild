# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Semantic versioning utilities, constraint parsing, and checking"
HOMEPAGE="https://github.com/composer/semver"
SRC_URI="https://github.com/composer/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-lang/php:*
	dev-php/fedora-autoloader"

src_install() {
	insinto "/usr/share/php/Composer/Semver"
	doins -r src/. "${FILESDIR}"/autoload.php
	dodoc README.md
}
