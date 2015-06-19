# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/gnome-rdp/gnome-rdp-0.3.0.9.ebuild,v 1.1 2011/08/19 11:36:00 voyageur Exp $

EAPI=4

inherit eutils mono

DESCRIPTION="Remote Desktop Client for the GNOME desktop"
HOMEPAGE="http://sourceforge.net/projects/gnome-rdp"
SRC_URI="mirror://sourceforge/gnome-rdp/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+rdesktop +vnc"

RDEPEND="dev-db/sqlite:3
		dev-dotnet/ndesk-dbus-glib
		dev-dotnet/gconf-sharp:2
		dev-dotnet/glade-sharp:2
		dev-dotnet/glib-sharp:2
		dev-dotnet/gtk-sharp:2
		>=dev-dotnet/gnome-keyring-sharp-1.0
		>=net-misc/openssh-3
		>=x11-terms/gnome-terminal-2
		rdesktop? ( >=net-misc/rdesktop-1.3 )
		vnc? ( >=net-misc/tightvnc-1.2 )"
DEPEND="${RDEPEND}"

src_install() {
	emake DESTDIR="${D}" install
	dodoc ChangeLog
	doicon Menu/${PN}.png
	domenu Menu/${PN}.desktop
}
