# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils autotools

DESCRIPTION="Cal3D is a skeletal based character animation library"
HOMEPAGE="http://home.gna.org/cal3d"
SRC_URI="http://download.gna.org/cal3d/sources/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~ia64 ppc x86 ~x86-fbsd"
IUSE="16bit-indices debug doc"

DEPEND="doc? (
		app-doc/doxygen
		app-text/docbook-sgml-utils
	)"
RDEPEND=""

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-gcc43.patch \
	    "${FILESDIR}"/${P}-tests.patch \
	    "${FILESDIR}"/${P}-verbose.patch
	sed -i \
		-e "s:db2html:docbook2html:g" \
		configure.in \
		docs/Makefile.am \
		|| die "sed for doc failed"
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable 16bit-indices)
}

src_compile() {
	emake
	if use doc; then
		cd docs
		emake doc-api
		emake doc-guide
		mkdir -p html/{guide,api}
		mv *.{html,gif} html/guide/
		mv api/html/* html/api/
	fi
}

src_install() {
	default
	use doc && dohtml -r docs/html/api docs/html/guide
}
