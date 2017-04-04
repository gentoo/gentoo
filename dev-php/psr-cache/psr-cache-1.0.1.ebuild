# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="PSR Cache interfaces defined by PSR-6"
HOMEPAGE="https://github.com/php-fig/cache"
SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-lang/php:*
	dev-php/fedora-autoloader"

S="${WORKDIR}/cache-${PV}"

src_install() {
	insinto "/usr/share/php/Psr/Cache"
	doins -r src/. "${FILESDIR}"/autoload.php
	dodoc README.md
}
