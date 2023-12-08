# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="${PN/PEAR-/}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Easily manipulate archives in PHP"
HOMEPAGE="https://pear.php.net/package/File_Archive"
SRC_URI="http://download.pear.php.net/package/${MY_P}.tgz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="minimal"

RDEPEND="dev-lang/php[bzip2,zlib]
	dev-php/PEAR-MIME_Type
	dev-php/PEAR-PEAR
	!minimal? (
		dev-php/PEAR-Mail_Mime
		dev-php/PEAR-Mail
		dev-php/PEAR-Cache_Lite
	)"

S="${WORKDIR}/${MY_P}"

src_install() {
	dodoc README

	insinto /usr/share/php
	doins -r File
}
