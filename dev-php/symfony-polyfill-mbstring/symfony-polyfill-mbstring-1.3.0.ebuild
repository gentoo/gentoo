# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Provides a partial, native PHP implementation for the Mbstring extension"
HOMEPAGE="https://github.com/symfony/polyfill-mbstring"
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
# Test exist in the main project, but now (2017-01-19) not in the subtree,
# For the moment only mbstring is needed but we could provide the main project
# if needed https://github.com/symfony/polyfill

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-lang/php:*
	dev-php/fedora-autoloader"

S="${WORKDIR}/polyfill-mbstring-${PV}"

src_install() {
	insinto "/usr/share/php/Symfony/Polyfill/Mbstring"
	doins -r Resources bootstrap.php LICENSE  Mbstring.php "${FILESDIR}"/autoload.php
	dodoc README.md
}
