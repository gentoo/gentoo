# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Semantic versioning utilities, constraint parsing, and checking"
HOMEPAGE="https://github.com/composer/semver"
SRC_URI="https://github.com/composer/semver/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-lang/php:*
	dev-php/fedora-autoloader"

# The releases don't contain the test suite at the moment, see
# https://github.com/composer/semver/issues/59

src_install() {
	insinto '/usr/share/php/Composer/Semver'
	doins -r src/. "${FILESDIR}/autoload.php"
	dodoc README.md
}
