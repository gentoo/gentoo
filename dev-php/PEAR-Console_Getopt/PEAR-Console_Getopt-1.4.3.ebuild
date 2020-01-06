# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN/PEAR-/}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Command-line option parser"
HOMEPAGE="https://pear.php.net/package/Console_Getopt"
SRC_URI="https://pear.php.net/get/${MY_P}.tgz"
LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""

DEPEND=""
RDEPEND="dev-lang/php:*"
PDEPEND="dev-php/PEAR-PEAR"

S="${WORKDIR}/${MY_P}"

src_install() {
	insinto /usr/share/php
	doins -r Console
}
