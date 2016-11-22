# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
GCONF_DEBUG="no"

inherit mono-env gnome2

DESCRIPTION="A RSS aggregator written in C#"
HOMEPAGE="https://git.gnome.org/browse/blam"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

RDEPEND="
	>=dev-lang/mono-2.6.0
	dev-dotnet/dbus-sharp-glib:1.0
	|| ( >=dev-dotnet/gtk-sharp-2.12.21 ( >=dev-dotnet/gtk-sharp-2.12.6 >=dev-dotnet/glade-sharp-2.12.6 ) )
	>=dev-dotnet/gconf-sharp-2.8.2
	dev-dotnet/notify-sharp
	>=dev-dotnet/webkit-sharp-0.2
	>=gnome-base/libgnomeui-2.2
	>=gnome-base/gconf-2.4
"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig
	>=dev-util/intltool-0.25
"

src_prepare() {
	# https://bugzilla.gnome.org/show_bug.cgi?id=702798
	sed -i -e 's/.png//' blam.desktop.in.in || die
	sed -i -e 's/Application;//' blam.desktop.in.in || die

	gnome2_src_prepare
}
