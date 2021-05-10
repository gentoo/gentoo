# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Tools for working with and validating SPDX licenses"
HOMEPAGE="https://github.com/composer/spdx-licenses"
SRC_URI="https://github.com/composer/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	dev-lang/php:*
	dev-php/fedora-autoloader"

src_install() {
	insinto "/usr/share/php/Composer/res"
	doins -r res/.

	insinto "/usr/share/php/Composer/Spdx"
	doins -r src/. "${FILESDIR}"/autoload.php
	dodoc README.md
}
