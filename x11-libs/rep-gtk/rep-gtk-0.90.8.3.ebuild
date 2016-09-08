# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools eutils

MY_P="${PN}_${PV}"
DESCRIPTION="GTK+/libglade/GNOME bindings for the librep Lisp environment"
HOMEPAGE="http://sawfish.wikia.com/wiki/Main_Page"
SRC_URI="http://download.tuxfamily.org/librep/${PN}/${MY_P}.tar.xz"

LICENSE="GPL-2"
SLOT="gtk-2.0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="examples"

RDEPEND=">=dev-libs/librep-0.90.5
	>=dev-libs/glib-2.6:2
	>=x11-libs/gtk+-2.24.0:2
	>=x11-libs/gdk-pixbuf-2.23:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	app-arch/xz-utils"

S="${WORKDIR}/${MY_P}"

DOCS=( AUTHORS ChangeLog README README.gtk-defs README.guile-gtk TODO )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--libdir=/usr/$(get_libdir) \
		--disable-static
}

src_install() {
	default
	use examples && dodoc -r examples
	find "${D}" -name '*.la' -exec rm -f {} + || die "la file removal failed"
}
