# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Promises/A implementation for PHP"
HOMEPAGE="https://github.com/reactphp/promise/"
SRC_URI="https://github.com/reactphp/promise/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-lang/php:*
	dev-php/fedora-autoloader"

src_install() {
	insinto '/usr/share/php/React/Promise'
	doins -r src/. "${FILESDIR}/autoload.php"
	dodoc README.md
}
