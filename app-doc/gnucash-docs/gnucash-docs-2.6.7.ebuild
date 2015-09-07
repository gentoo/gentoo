# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
GCONF_DEBUG=no

inherit gnome2

DESCRIPTION="Documentation package for GnuCash"
HOMEPAGE="http://www.gnucash.org/"
SRC_URI="mirror://sourceforge/gnucash/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2 FDL-1.1"
KEYWORDS="amd64 ~ppc ~ppc64 ~x86"
IUSE="test"

RDEPEND="!<=app-office/gnucash-2.2.1"
DEPEND="${RDEPEND}
	>=dev-libs/libxml2-2.5.10
	dev-libs/libxslt
	app-text/docbook-xsl-stylesheets
	app-text/docbook-xml-dtd:4.1.2
	app-text/rarian
	test? ( app-text/docbook-xml-dtd:4.4 )
"

pkg_postinst() {
	gnome2_pkg_postinst
	has_version dev-java/fop || elog "You need dev-java/fop to generate pdf files."
	has_version gnome-extra/yelp || elog "You need gnome-extra/yelp to view the docs."
}
