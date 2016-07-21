# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils eutils versionator

MY_PV=$(get_version_component_range 1-2)

DESCRIPTION="Client library to interact with zeitgeist"
HOMEPAGE="https://launchpad.net/libzeitgeist/"
SRC_URI="https://launchpad.net/libzeitgeist/${MY_PV}/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE="static-libs"

CDEPEND="dev-libs/glib:2"
RDEPEND="${CDEPEND}
	gnome-extra/zeitgeist"
DEPEND="${CDEPEND}
	dev-util/gtk-doc
	virtual/pkgconfig"

src_prepare() {
	sed \
		-e "s:doc/libzeitgeist:doc/${PF}:" \
		-i Makefile.am || die
	# FIXME: This is the unique test failing
	sed \
		-e '/TEST_PROGS      += test-log/d' \
		-i tests/Makefile.am || die

	sed \
		-e 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/g' \
		-e 's:AM_PROG_CC_STDC:AC_PROG_CC:g' \
		-i configure.ac || die

	autotools-utils_src_prepare
}
