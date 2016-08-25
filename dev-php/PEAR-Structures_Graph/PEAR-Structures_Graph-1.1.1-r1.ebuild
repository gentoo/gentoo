# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MY_PN="${PN/PEAR-/}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Graph datastructure manipulation library"
HOMEPAGE="http://pear.php.net/package/${MY_PN}"
SRC_URI="http://pear.php.net/get/${MY_P}.tgz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""

DEPEND=""
RDEPEND="dev-lang/php:*"
PDEPEND="dev-php/PEAR-PEAR"

S="${WORKDIR}/${MY_P}"

src_install() {
	insinto /usr/share/php
	doins -r Structures
}
