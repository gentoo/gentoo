# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

HOMEPAGE="https://pear.php.net/package/MIME_Type"
SRC_URI="https://pear.php.net/get/${P#PEAR-}.tgz"
DESCRIPTION="Utility class for dealing with MIME types"
LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 ~hppa ppc ppc64 ~sparc x86"
IUSE=""
RDEPEND=">=dev-lang/php-5.4:*
	>=dev-php/pear-1.9
	dev-php/PEAR-System_Command"
S="${WORKDIR}/${P#PEAR-}"

src_install() {
	insinto /usr/share/php
	doins -r MIME
}
