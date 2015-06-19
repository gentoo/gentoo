# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-Structures_Graph/PEAR-Structures_Graph-1.0.4-r2.ebuild,v 1.1 2015/04/15 02:17:47 grknight Exp $

# BIG FAT WARNING!
# Do not use any pear eclass here since pear itself depends on this package.
# Using the pear eclass will thus create a circular dependency

EAPI="5"

MY_PN="${PN/PEAR-/}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Graph datastructure manipulation library"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""
SRC_URI="http://pear.php.net/get/${MY_P}.tgz"
DEPEND="dev-lang/php:*[pcre(+)]
		>=dev-php/PEAR-PEAR-1.8.1"
RDEPEND="${DEPEND}"
PDEPEND="dev-php/pear"
HOMEPAGE="http://pear.php.net/package/Structures_Graph"

S="${WORKDIR}/${MY_P}"

src_install() {
	insinto /usr/share/php
	doins -r Structures

	dohtml -r docs/html/*
}
