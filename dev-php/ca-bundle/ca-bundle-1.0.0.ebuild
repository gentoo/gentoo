# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Find a path to the system CA bundle, and fallback to the Mozilla CA bundle"
HOMEPAGE="https://github.com/composer/ca-bundle"
SRC_URI="https://github.com/composer/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-lang/php:*
	dev-php/fedora-autoloader"

src_install() {
	insinto "/usr/share/php/Composer/CaBundle"
	doins -r src/. "${FILESDIR}"/autoload.php
	dodoc README.md
}
