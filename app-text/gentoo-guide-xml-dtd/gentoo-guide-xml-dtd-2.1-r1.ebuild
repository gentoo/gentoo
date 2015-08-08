# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit sgml-catalog

S=${WORKDIR}
DESCRIPTION="DTD for Gentoo-Guide Style XML Files"
HOMEPAGE="http://www.gentoo.org"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc s390 sparc x86"
IUSE=""

DEPEND=">=app-text/sgml-common-0.6.1"

src_unpack() {
	# Nothing to unpack
	return 0
}

src_install () {

	cd ${FILESDIR}

	insinto /usr/share/sgml/guide
	doins catalog
	insinto /usr/share/sgml/guide/ent
	doins ent/*.ent
	insinto /usr/share/sgml/guide/xml-dtd-2.1
	newins guide/guide-2.1.dtd guide.dtd

}

sgml-catalog_cat_include "/etc/sgml/gentoo-guide.cat" \
	"/usr/share/sgml/guide/catalog"
