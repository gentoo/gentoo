# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/awl/awl-0.55-r1.ebuild,v 1.1 2015/05/02 02:06:18 grknight Exp $

EAPI=5

DESCRIPTION="Andrew McMillan's Web Libraries"
HOMEPAGE="https://gitlab.com/davical-project/awl"
SRC_URI="${HOMEPAGE}/repository/archive.tar.gz?ref=r${PV} -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

DEPEND="test? ( dev-php/phpunit )"
RDEPEND="dev-lang/php:*[pdo,postgres,xml]"
S="${WORKDIR}/${PN}.git"

src_compile() {
	:
}

src_test() {
	phpunit tests/ || die "test suite failed"
}

src_install() {
	dodoc debian/changelog
	use doc && dohtml -r "docs/api/"
	insinto "/usr/share/php/${PN}"
	doins -r dba inc
}
