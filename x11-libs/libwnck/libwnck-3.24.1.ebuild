# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"

inherit flag-o-matic gnome2

DESCRIPTION="A window navigation construction kit"
HOMEPAGE="https://developer.gnome.org/libwnck/stable/"

LICENSE="LGPL-2+"
SLOT="3"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-solaris ~x86-solaris"

IUSE="+introspection startup-notification tools"

RDEPEND="
	x11-libs/cairo[X]
	>=x11-libs/gtk+-3.22:3[introspection?]
	>=dev-libs/glib-2.32:2
	x11-libs/libX11
	x11-libs/libXres
	x11-libs/libXext
	introspection? ( >=dev-libs/gobject-introspection-0.6.14:= )
	startup-notification? ( >=x11-libs/startup-notification-0.4 )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.9
	>=sys-devel/gettext-0.19.4
	virtual/pkgconfig
"
# eautoreconf needs
#	sys-devel/autoconf-archive

src_configure() {
	# Don't collide with SLOT=1
	gnome2_src_configure \
		--disable-static \
		$(use_enable introspection) \
		$(use_enable startup-notification) \
		$(use_enable tools) \
		--program-suffix=-${SLOT}
}
