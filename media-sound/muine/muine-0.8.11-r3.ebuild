# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
GCONF_DEBUG="yes"

inherit gnome2 mono-env eutils multilib

DESCRIPTION="A music player for GNOME"
HOMEPAGE="http://muine.gooeylinux.org/"
SRC_URI="mirror://gnome/sources/muine/0.8/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="flac mad vorbis"

RDEPEND="
	x11-themes/gnome-icon-theme
	>=dev-lang/mono-2
	>=x11-libs/gtk+-2.6:2
	>=dev-dotnet/gtk-sharp-2.12.9:2
	>=dev-dotnet/glade-sharp-2.12.6:2
	>=dev-dotnet/gnome-sharp-2.6:2
	>=dev-dotnet/gconf-sharp-2.6:2
	>=dev-dotnet/gnomevfs-sharp-2.6:2
	>=dev-dotnet/ndesk-dbus-0.4
	>=dev-dotnet/ndesk-dbus-glib-0.3
	>=dev-dotnet/taglib-sharp-2.0.3
	sys-libs/gdbm
	media-libs/gstreamer:0.10
	media-libs/gst-plugins-base:0.10
	media-libs/gst-plugins-good:0.10
	media-plugins/gst-plugins-gconf:0.10
	media-plugins/gst-plugins-gnomevfs:0.10
	flac? ( media-plugins/gst-plugins-flac:0.10 )
	mad? ( media-plugins/gst-plugins-mad:0.10 )
	vorbis? (
		media-plugins/gst-plugins-ogg:0.10
		media-plugins/gst-plugins-vorbis:0.10
	)
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	app-text/scrollkeeper
	gnome-base/gnome-common
	>=dev-util/intltool-0.29
"

src_prepare() {
	DOCS="AUTHORS ChangeLog HACKING MAINTAINERS NEWS PLUGINS README TODO"

	# Fix multimedia key support for >=Gnome-2.22
	epatch "${FILESDIR}/${P}-multimedia-keys.patch"

	# Replace some deprecated gtk functions
	epatch "${FILESDIR}/${P}-drop-deprecated.patch"

	# Update icons, upstream bug #623480
	sed "s:stock_timer:list-add:g" -i src/AddWindow.cs src/StockIcons.cs || die
	sed "s:stock_music-library:folder-music:g" -i data/glade/PlaylistWindow.glade \
		src/Actions.cs src/StockIcons.cs || die

	# Fix intltoolize broken file, see upstream #577133
	sed "s:'\^\$\$lang\$\$':\^\$\$lang\$\$:g" -i po/Makefile.in.in \
		|| die "sed failed"

	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure --disable-static
}

src_install() {
	gnome2_src_install
	insinto /usr/$(get_libdir)/${PN}/plugins
	doins "${S}"/plugins/TrayIcon.dll
}
