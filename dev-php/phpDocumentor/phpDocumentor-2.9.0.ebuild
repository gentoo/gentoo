# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Automatic documenting of php api directly from the source"
HOMEPAGE="http://phpdoc.org"
SRC_URI="https://github.com/${PN}/${PN}2/releases/download/v${PV}/${PN}.phar -> ${P}.phar"

LICENSE="MIT"
SLOT="0"

KEYWORDS="~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

# block old version that provides the same binary
RDEPEND="!dev-php/PEAR-PhpDocumentor
	media-gfx/graphviz
	dev-lang/php:*[cli,iconv,intl,phar,xmlreader,xslt]"
S="${WORKDIR}"

src_unpack() { :; }

src_install() {
	exeinto /usr/share/php/${PN}
	newexe "${DISTDIR}/${P}.phar" ${PN}.phar
	dosym "../share/php/${PN}/${PN}.phar" /usr/bin/phpdoc
}
