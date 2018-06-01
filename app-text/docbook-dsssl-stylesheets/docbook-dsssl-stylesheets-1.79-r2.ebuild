# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit sgml-catalog

MY_P=${P/-stylesheets/}
S=${WORKDIR}/${MY_P}
DESCRIPTION="DSSSL Stylesheets for DocBook"
HOMEPAGE="https://github.com/docbook/wiki/wiki"
SRC_URI="mirror://sourceforge/docbook/${MY_P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x64-solaris"
IUSE=""

RDEPEND="app-text/sgml-common"

sgml-catalog_cat_include "/etc/sgml/dsssl-docbook-stylesheets.cat" \
	"/usr/share/sgml/docbook/dsssl-stylesheets-${PV}/catalog"
sgml-catalog_cat_include "/etc/sgml/sgml-docbook.cat" \
	"/etc/sgml/dsssl-docbook-stylesheets.cat"

src_unpack() {
	unpack ${A}
	cd "${S}"
	cp "${FILESDIR}/${PN}-1.77.Makefile" Makefile
}

src_compile() {
	return 0
}

src_install() {
	make \
		BINDIR="${ED}/usr/bin" \
		DESTDIR="${ED}/usr/share/sgml/docbook/dsssl-stylesheets-${PV}" \
		install || die

	dodir /usr/share/sgml/stylesheets/dsssl/

	if [ -d "${EPREFIX}"/usr/share/sgml/stylesheets/dsssl/docbook ] &&
		[ ! -L "${EPREFIX}"/usr/share/sgml/stylesheets/dsssl/docbook ]
	then
		ewarn "Not linking /usr/share/sgml/stylesheets/dsssl/docbook to"
		ewarn "/usr/share/sgml/docbook/dsssl-stylesheets-${PV}"
		ewarn "as directory already exists there.  Will assume you know"
		ewarn "what you're doing."
	else
		dosym ../../docbook/dsssl-stylesheets-${PV} \
			/usr/share/sgml/stylesheets/dsssl/docbook
	fi

	dodoc BUGS ChangeLog README RELEASE-NOTES.txt WhatsNew
}
