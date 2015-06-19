# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libwnck/libwnck-2.31.0.ebuild,v 1.12 2015/03/03 11:42:10 dlan Exp $

EAPI="4"
GNOME2_LA_PUNT="yes"
GCONF_DEBUG="no"

inherit flag-o-matic gnome2

DESCRIPTION="A window navigation construction kit"
HOMEPAGE="http://www.gnome.org/"

LICENSE="LGPL-2+"
SLOT="1"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-solaris ~x86-solaris"

IUSE="doc +introspection startup-notification"

RDEPEND=">=x11-libs/gtk+-2.19.7:2[introspection?]
	>=dev-libs/glib-2.16:2
	x11-libs/libX11
	x11-libs/libXres
	x11-libs/libXext
	introspection? ( >=dev-libs/gobject-introspection-0.6.14 )
	startup-notification? ( >=x11-libs/startup-notification-0.4 )"
DEPEND="${RDEPEND}
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.40
	sys-devel/gettext
	virtual/pkgconfig
	x86-interix? ( sys-libs/itx-bind )"
# eautoreconf needs
#	gnome-base/gnome-common

src_prepare() {
	G2CONF="${G2CONF}
		--disable-static
		$(use_enable introspection)
		$(use_enable startup-notification)"
	DOCS="AUTHORS ChangeLog HACKING NEWS README"

	# Regenerate pregenerated marshalers for <glib-2.31 compatibility
	rm -v libwnck/wnck-marshal.{c,h} || die "rm failed"

	gnome2_src_prepare

	if use x86-interix; then
		# activate the itx-bind package...
		append-flags "-I${EPREFIX}/usr/include/bind"
		append-ldflags "-L${EPREFIX}/usr/lib/bind"
	fi
}
