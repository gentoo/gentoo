# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="The phpDocumentor package provides automatic documenting of php api directly from the source"
HOMEPAGE="http://phpdoc.org"
SRC_URI="https://github.com/${PN}/${PN}2/releases/download/v${PV}/${PN}.phar -> ${P}.phar"

LICENSE="MIT"
SLOT="0"

KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

# block old version that provides the same binary
DEPEND="!dev-php/PEAR-PhpDocumentor"
RDEPEND="media-gfx/graphviz
	dev-lang/php:*[cli,iconv,intl,phar,xmlreader,xslt]"
S="${WORKDIR}"

src_unpack() { :; }

src_install() {
	insinto /usr/share/php/${PN}
	insopts -m755
	newins "${DISTDIR}/${P}.phar" ${PN}.phar
	dosym /usr/share/php/${PN}/${PN}.phar /usr/bin/phpdoc
}
