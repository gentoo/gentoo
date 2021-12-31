# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
GNOME2_LA_PUNT="yes"
GCONF_DEBUG="no"

inherit flag-o-matic gnome2

DESCRIPTION="A window navigation construction kit"
HOMEPAGE="https://www.gnome.org/"

LICENSE="LGPL-2+"
SLOT="1"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ia64 ~mips ppc ppc64 sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-solaris ~x86-solaris"

IUSE="+introspection startup-notification"

RDEPEND="
	>=x11-libs/gtk+-2.19.7:2[introspection?]
	>=dev-libs/glib-2.16:2
	x11-libs/libX11
	x11-libs/libXres
	x11-libs/libXext
	introspection? ( >=dev-libs/gobject-introspection-0.6.14:= )
	startup-notification? ( >=x11-libs/startup-notification-0.4 )
"
DEPEND="${RDEPEND}
	dev-util/glib-utils
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.40
	sys-devel/gettext
	virtual/pkgconfig
"
# eautoreconf needs
#	gnome-base/gnome-common

src_prepare() {
	DOCS="AUTHORS ChangeLog HACKING NEWS README"

	# Regenerate pregenerated marshalers for <glib-2.31 compatibility
	rm -v libwnck/wnck-marshal.{c,h} || die "rm failed"

	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-static \
		$(use_enable introspection) \
		$(use_enable startup-notification)
}
