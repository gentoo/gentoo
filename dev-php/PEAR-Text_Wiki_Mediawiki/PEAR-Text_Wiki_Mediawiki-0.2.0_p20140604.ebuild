# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit php-pear-r2 vcs-snapshot

SRC_URI="https://github.com/pear/Text_Wiki_Mediawiki/archive/11a902741d3f8cc6010fb97b825d66345143e4dc.tar.gz -> ${PEAR_P}.tar.gz"
DESCRIPTION="Mediawiki parser for Text_Wiki"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"
RDEPEND=">=dev-php/PEAR-Text_Wiki-1.2.2_p20170904"
DEPEND="test? ( ${RDEPEND} dev-php/phpunit )"
PATCHES=( "${FILESDIR}/0.2.0-constructor.patch" )

src_test() {
	phpunit tests/Text_Wiki_Parse_Mediawiki_Test.php || die
}

src_install() {
	php-pear-r2_src_install
	insinto /usr/share/php/.packagexml
	newins package.xml "${PEAR_P}.xml"
}
