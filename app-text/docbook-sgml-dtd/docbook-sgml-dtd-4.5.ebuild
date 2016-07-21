# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils sgml-catalog

MY_P="docbook-${PV}"
DESCRIPTION="Docbook SGML DTD 4.5"
HOMEPAGE="http://www.docbook.org/sgml/"
SRC_URI="http://www.docbook.org/sgml/${PV}/${MY_P}.zip"

LICENSE="docbook"
SLOT="4.5"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x64-solaris"
IUSE=""

DEPEND=">=app-arch/unzip-5.41"
RDEPEND="app-text/sgml-common"

S=${WORKDIR}

sgml-catalog_cat_include "/etc/sgml/sgml-docbook-${PV}.cat" \
	"/usr/share/sgml/docbook/sgml-dtd-${PV}/catalog"
sgml-catalog_cat_include "/etc/sgml/sgml-docbook-${PV}.cat" \
	"/etc/sgml/sgml-docbook.cat"

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}"/${P}-catalog.diff
}

src_install() {
	insinto /usr/share/sgml/docbook/sgml-dtd-${PV}
	doins *.dcl *.dtd *.mod *.xml || die "doins failed"
	newins docbook.cat catalog || die "newins failed"

	dodoc README
}
