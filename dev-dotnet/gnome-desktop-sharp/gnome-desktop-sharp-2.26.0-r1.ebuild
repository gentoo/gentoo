# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

GTK_SHARP_REQUIRED_VERSION="2.12"
GTK_SHARP_MODULE_DIR="gnomedesktop"

inherit eutils gtk-sharp-module

SLOT="2"
KEYWORDS="amd64 ppc x86"
IUSE=""

RESTRICT="test"

add_rdepend ">=gnome-base/gnome-desktop-2.30:2"

src_prepare() {
	# Update soname to fit with gnome-desktop-2.30
	epatch "${FILESDIR}/${P}-soname.patch"
	gtk-sharp-module_src_prepare
}
