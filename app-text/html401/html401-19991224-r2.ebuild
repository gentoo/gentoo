# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/html401/html401-19991224-r2.ebuild,v 1.14 2012/03/28 09:59:20 ago Exp $

EAPI=3

inherit sgml-catalog eutils

DESCRIPTION="DTDs for the HyperText Markup Language 4.01"
HOMEPAGE="http://www.w3.org/TR/html401/"
SRC_URI="http://www.w3.org/TR/html401/html40.tgz"

LICENSE="W3C"
SLOT="0"
KEYWORDS="amd64 ppc s390 x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""
DEPEND="app-text/sgml-common"
RDEPEND=""

S=${WORKDIR}

src_prepare() {
	sgml-catalog_cat_include "/etc/sgml/${PN}.cat" \
		"/usr/share/sgml/${PN}/HTML4.cat"
	epatch "${FILESDIR}"/${PN}-decl.diff
}

src_install() {
	insinto /usr/share/sgml/${PN}
	doins HTML4.cat HTML4.decl *.dtd *.ent
	insinto /etc/sgml
	dohtml -r *.html $(ls -p | fgrep "/" | sed "s#/##")
}
