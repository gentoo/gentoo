# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/awl/awl-0.53-r2.ebuild,v 1.1 2015/05/02 02:06:18 grknight Exp $

EAPI=5

DESCRIPTION="Andrew McMillan's web libraries: A collection of generic classes
used by the davical calendar server"
HOMEPAGE="http://andrew.mcmillan.net.nz/projects/awl"
SRC_URI="http://debian.mcmillan.net.nz/packages/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="dev-lang/php:*[pdo,postgres,xml]"

DOCS=( debian/README.Debian debian/changelog )

src_compile() {
	:
}

src_install() {
	dodoc "${DOCS[@]}"
	use doc && dohtml -r "docs/api/"
	insinto "/usr/share/php/${PN}"
	doins -r dba inc scripts
}
