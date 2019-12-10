# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
GNOME_TARBALL_SUFFIX="bz2"

inherit gnome2

DESCRIPTION="User Interface routines for Gnome"
HOMEPAGE="https://library.gnome.org/devel/libgnomeui/stable/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-linux ~x86-linux ~sparc-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

# gtk+-2.14 dep instead of 2.12 ensures system doesn't loose VFS capabilities in GtkFilechooser
RDEPEND="
	dev-libs/atk
	>=dev-libs/glib-2.16:2
	>=dev-libs/libxml2-2.4.20:2
	>=dev-libs/popt-1.5
	>=gnome-base/gconf-2:2
	>=gnome-base/gnome-keyring-0.4
	>=gnome-base/gnome-vfs-2.7.3:2
	>=gnome-base/libgnome-2.13.7
	>=gnome-base/libgnomecanvas-2
	gnome-base/libgnome-keyring
	>=gnome-base/libbonoboui-2.13.1
	>=gnome-base/libglade-2:2.0
	media-libs/libart_lgpl
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-2.14:2
	>=x11-libs/pango-1.1.2
	x11-libs/libICE
	x11-libs/libSM
"
DEPEND="${RDEPEND}
	dev-util/gtk-doc-am
	sys-devel/gettext
	virtual/pkgconfig
	>=dev-util/intltool-0.40
"
PDEPEND="x11-themes/adwaita-icon-theme"

src_prepare() {
	if ! use test; then
		sed 's/ test-gnome//' -i Makefile.am Makefile.in || die "sed failed"
	fi
	gnome2_src_prepare
}
