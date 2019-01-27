# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# EAPI=6 is blocked by Gentoo bug 497052.
EAPI=5

MY_P=${P/-stylesheets/}

inherit sgml-catalog

DESCRIPTION="DSSSL Stylesheets for DocBook"
HOMEPAGE="https://github.com/docbook/wiki/wiki"
SRC_URI="mirror://sourceforge/docbook/${MY_P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x64-solaris"
IUSE=""

RDEPEND="
	app-text/sgml-common
	app-text/docbook-sgml-dtd:3.0
"

DOCS=( BUGS ChangeLog README RELEASE-NOTES.txt WhatsNew )

S="${WORKDIR}/${MY_P}"

src_install() {
	local dsssldir CATALOG_DIR=usr/share/sgml/docbook/dsssl-stylesheets-${PV}

	dobin bin/collateindex.pl

	insinto ${CATALOG_DIR}
	doins catalog VERSION

	insinto ${CATALOG_DIR}/common
	doins common/*.{dsl,ent}

	insinto ${CATALOG_DIR}/images
	doins images/*.gif

	for dsssldir in html lib olink print; do
		insinto ${CATALOG_DIR}/${dsssldir}
		doins ${dsssldir}/*.dsl
	done

	for dsssldir in dbdsssl html imagelib olink; do
		insinto ${CATALOG_DIR}/dtds/${dsssldir}
		doins dtds/${dsssldir}/*.dtd
	done

	insinto ${CATALOG_DIR}/dtds/html
	doins dtds/html/*.{dcl,gml}

	dodoc "${DOCS[@]}"
}

sgml-catalog_cat_include \
	"/etc/sgml/dsssl-docbook-stylesheets.cat" \
	"/usr/share/sgml/docbook/dsssl-stylesheets-${PV}/catalog"

sgml-catalog_cat_include \
	"/etc/sgml/sgml-docbook.cat" \
	"/etc/sgml/dsssl-docbook-stylesheets.cat"
