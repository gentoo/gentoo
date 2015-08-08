# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

VALA_MIN_API_VERSION=0.16

inherit autotools-utils versionator vala

MY_PV=$(get_version_component_range 1-2)

DESCRIPTION="Provides passive plugins to insert events into zeitgeist"
HOMEPAGE="http://launchpad.net/zeitgeist-datahub"
SRC_URI="http://launchpad.net/zeitgeist-datahub/${MY_PV}/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="download telepathy"

CDEPEND="
	!>=gnome-extra/zeitgeist-0.9.12
	dev-libs/libzeitgeist
	>=dev-libs/json-glib-0.14.0
	dev-libs/glib:2
	x11-libs/gtk+:2
	telepathy? ( >=net-libs/telepathy-glib-0.18.0 )"
RDEPEND="${CDEPEND}"
DEPEND="${CDEPEND}
	$(vala_depend)
	virtual/pkgconfig"
PDEPEND="gnome-extra/zeitgeist"

src_prepare() {
	sed \
		-e '/Encoding/d' \
		-i src/${PN}.desktop.in || die
	rm -f src/zeitgeist-datahub.c || die
	vala_src_prepare
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		$(use_enable telepathy)
		$(use_enable download downloads-monitor)
		--disable-silent-rules
	)
	autotools-utils_src_configure
}
