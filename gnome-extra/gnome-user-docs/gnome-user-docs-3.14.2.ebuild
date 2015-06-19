# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome-user-docs/gnome-user-docs-3.14.2.ebuild,v 1.3 2015/03/15 13:26:26 pacho Exp $

EAPI="5"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="GNOME end user documentation"
HOMEPAGE="https://git.gnome.org/browse/gnome-user-docs"

LICENSE="CC-BY-3.0"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc x86 ~x86-fbsd"
IUSE="test"

RDEPEND=""
DEPEND="
	test? ( dev-libs/libxml2 )
"
# eautoreconf requires:
#	app-text/yelp-tools
# rebuilding translations requires:
#	app-text/yelp-tools
#	dev-util/gettext

# This ebuild does not install any binaries
RESTRICT="binchecks strip"

src_configure() {
	# itstool is only needed for rebuilding translations
	# xmllint is only needed for tests
	gnome2_src_configure \
		$(usex test "" XMLLINT=$(type -P true)) \
		ITSTOOL=$(type -P true)
}

src_compile() {
	# Do not compile; "make all" with unset LINGUAS rebuilds all translations,
	# which can take > 2 hours on a Core i7.
	return
}
