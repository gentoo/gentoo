# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Symfony Filesystem Component"
HOMEPAGE="https://github.com/symfony/filesystem"
SRC_URI="https://github.com/symfony/filesystem/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-lang/php:*
	dev-php/fedora-autoloader"

S="${WORKDIR}/filesystem-${PV}"

src_install() {
	insinto "/usr/share/php/Symfony/Component/Filesystem"
	doins -r . "${FILESDIR}"/autoload.php
	dodoc README.md
}
