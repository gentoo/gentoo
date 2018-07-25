# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools gnome2

DESCRIPTION="Documentation package for GnuCash"
HOMEPAGE="http://www.gnucash.org/"
SRC_URI="https://github.com/Gnucash/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2 FDL-1.1"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="test"

RDEPEND="!<=app-office/gnucash-2.2.1"
DEPEND="${RDEPEND}
	>=dev-libs/libxml2-2.5.10:2
	dev-libs/libxslt
	app-text/docbook-xsl-stylesheets
	app-text/docbook-xml-dtd:4.1.2
	app-text/rarian
	test? ( app-text/docbook-xml-dtd:4.4 )
"

src_prepare() {
	default
	eautoreconf
}

pkg_postinst() {
	gnome2_pkg_postinst
	has_version dev-java/fop || elog "You need dev-java/fop to generate pdf files."
	has_version gnome-extra/yelp || elog "You need gnome-extra/yelp to view the docs."
}
