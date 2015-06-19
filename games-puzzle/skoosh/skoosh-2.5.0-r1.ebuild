# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/skoosh/skoosh-2.5.0-r1.ebuild,v 1.4 2014/12/05 10:18:25 ago Exp $

EAPI=5
GCONF_DEBUG="yes"

inherit eutils gnome2

DESCRIPTION="Sliding tile puzzle for Gnome 2"
HOMEPAGE="http://homepages.ihug.co.nz/~trmusson/programs.html"
SRC_URI="http://homepages.ihug.co.nz/~trmusson/stuff/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="nls"

RDEPEND="
	>=gnome-base/gconf-2:2
	gnome-base/libgnome-keyring
	>=gnome-base/libgnomeui-2
	nls? ( virtual/libintl )
"
# needs scrollkeeper-preinstall from rarian to build
DEPEND="${RDEPEND}
	app-text/rarian
	nls? ( sys-devel/gettext )
"

src_prepare() {
	# Fix .desktop file
	epatch "${FILESDIR}/${PN}-2.5.0-desktop.patch"

	# Need to apply omf fix or else we get access
	# violation errors related to sandbox.
	gnome2_omf_fix "${S}/help/C/Makefile.in"

	gnome2_src_prepare
}
