# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Tools for working with the SPDX license list and validating licenses"
HOMEPAGE="https://github.com/composer/spdx-licenses"
SRC_URI="https://github.com/composer/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-lang/php:*
	dev-php/fedora-autoloader"

PATCHES=(
	"${FILESDIR}/${PN}-change-res-path.patch"
)

src_install() {
	insinto "/usr/share/php/Composer/Spdx"
	doins -r src/. res "${FILESDIR}"/autoload.php
	dodoc README.md
}
