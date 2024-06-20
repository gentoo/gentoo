# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN/PEAR-/}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Graph datastructure manipulation library"
HOMEPAGE="https://pear.php.net/package/Structures_Graph"
SRC_URI="https://pear.php.net/get/${MY_P}.tgz"
S="${WORKDIR}/${MY_P}"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ppc64 ~s390 ~sparc x86"

RDEPEND="dev-lang/php:*"
PDEPEND="dev-php/PEAR-PEAR"

src_install() {
	insinto /usr/share/php
	doins -r Structures
}
