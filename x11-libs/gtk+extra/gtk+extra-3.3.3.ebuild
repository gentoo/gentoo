# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2

DESCRIPTION="Useful Additional GTK+ widgets"
HOMEPAGE="http://gtkextra.sourceforge.net"
SRC_URI="mirror://sourceforge/gtkextra/gtkextra-${PV}.tar.gz"

LICENSE="FDL-1.1 LGPL-2"
SLOT="0"
KEYWORDS="amd64 ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE="+introspection static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=x11-libs/gtk+-2.12.0:2
	dev-libs/glib:2
	introspection? ( >=dev-libs/gobject-introspection-0.6.14:= )
"
DEPEND="${RDEPEND}
	dev-util/glib-utils
	virtual/pkgconfig
"
# dev-libs/gobject-introspection-common needed for eautoreconf

S="${WORKDIR}/gtkextra-${PV}"

src_configure() {
	gnome2_src_configure \
		--enable-glade=no \
		--disable-man \
		$(use_enable introspection) \
		$(use_enable static-libs static) \
		$(use_enable test tests)
}
