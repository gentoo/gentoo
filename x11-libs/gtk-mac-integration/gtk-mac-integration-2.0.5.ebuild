# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/gtk-mac-integration/gtk-mac-integration-2.0.5.ebuild,v 1.2 2014/01/23 21:17:20 grobian Exp $

EAPI=5

DESCRIPTION="Menubar, doc and app bundle integration for GTK+"
HOMEPAGE="https://wiki.gnome.org/Projects/GTK%2B/OSX/Integration"
SRC_URI="https://download.gnome.org/sources/${PN}/2.0/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x64-macos"
IUSE=""

DEPEND="virtual/pkgconfig
	>=dev-libs/glib-2.14.0
	x11-libs/gtk+[aqua]"

RDEPEND="${DEPEND}"

src_configure() {
	econf --enable-python=no
}
