# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="${PN/PEAR-/}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A package for syntax highlighting"
HOMEPAGE="https://pear.php.net/package/Text_Highlighter"
SRC_URI="http://download.pear.php.net/package/${MY_P}.tgz"
LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# There is a documented dependency on XML_Parser, but that's only needed
# for development -- if you want to *generate* the PHP class files. The
# ones in the release are already pre-generated. The dependency on the
# XML_Serializer, on the other hand, is not documented but is requird
# by the XML output renderer.
RDEPEND="dev-lang/php
	dev-php/PEAR-PEAR
	dev-php/PEAR-XML_Serializer"

S="${WORKDIR}/${MY_P}"

src_install() {
	dodoc README TODO

	insinto /usr/share/php
	doins -r Text
}
