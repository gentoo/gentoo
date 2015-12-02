# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

DESCRIPTION="Static code analyser for PHP"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
HOMEPAGE="http://www.pdepend.org"
SRC_URI="http://static.pdepend.org/php/${PV}/pdepend.phar -> ${P}.phar"

RDEPEND=">=dev-lang/php-5.2.3:*[phar]"
S="${WORKDIR}"

src_unpack() { :; }

src_install() {
	insinto /usr/share/php/${PN}
	insopts -m755
	newins "${DISTDIR}/${P}.phar" ${PN}.phar
	dosym /usr/share/php/${PN}/${PN}.phar /usr/bin/${PN}
}
