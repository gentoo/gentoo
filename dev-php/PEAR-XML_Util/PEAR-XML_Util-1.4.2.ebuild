# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="${PN/PEAR-/}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="XML utility class"
HOMEPAGE="https://pear.php.net/package/XML_Util"
SRC_URI="https://pear.php.net/get/${MY_P}.tgz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ia64 ppc ppc64 ~s390 sparc x86"
IUSE="examples"

# PCRE is needed for a few calls to preg_replace and preg_match.
RDEPEND="dev-lang/php:*[pcre(+)]"
PDEPEND="dev-php/PEAR-PEAR"
DEPEND=""

S="${WORKDIR}/${MY_P}"

src_install() {
	insinto /usr/share/php
	doins -r XML

	use examples && dodoc -r examples
}
