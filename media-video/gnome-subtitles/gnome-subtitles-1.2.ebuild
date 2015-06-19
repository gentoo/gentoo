# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/gnome-subtitles/gnome-subtitles-1.2.ebuild,v 1.5 2012/08/18 12:30:54 xmw Exp $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit mono gnome2

DESCRIPTION="Video subtitling for the Gnome desktop"
HOMEPAGE="http://gnome-subtitles.sourceforge.net/"
SRC_URI="mirror://sourceforge/gnome-subtitles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="amd64 ppc x86"

RDEPEND=">=dev-lang/mono-1.1
	>=dev-dotnet/glade-sharp-2.12
	>=dev-dotnet/gtk-sharp-2.12
	>=dev-dotnet/gconf-sharp-2.12
	media-libs/gstreamer:0.10
	>=app-text/gtkspell-2.0:2
	>=app-text/enchant-1.3
	media-libs/gst-plugins-base:0.10"
DEPEND="${RDEPEND}
	app-text/scrollkeeper
	virtual/pkgconfig
	app-text/gnome-doc-utils"

DOCS="AUTHORS ChangeLog NEWS README"
