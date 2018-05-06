# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit sgml-catalog eutils

MY_P="docbook-${PV}"
DESCRIPTION="Docbook SGML DTD 4.3"
HOMEPAGE="http://docbook.org/sgml/"
SRC_URI="http://www.docbook.org/sgml/${PV}/${MY_P}.zip"

LICENSE="docbook"
SLOT="4.3"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x64-solaris"
IUSE=""

DEPEND=">=app-arch/unzip-5.41"
RDEPEND="app-text/sgml-common"

S="${WORKDIR}"

sgml-catalog_cat_include "/etc/sgml/sgml-docbook-${PV}.cat" \
	"/usr/share/sgml/docbook/sgml-dtd-${PV}/catalog"
sgml-catalog_cat_include "/etc/sgml/sgml-docbook-${PV}.cat" \
	"/etc/sgml/sgml-docbook.cat"

src_prepare() {
	default
	epatch "${FILESDIR}"/${P}-catalog.diff
}

src_install() {
	insinto /usr/share/sgml/docbook/sgml-dtd-${PV}
	doins *.dcl *.dtd *.mod
	newins docbook.cat catalog
	dodoc ChangeLog README
}
