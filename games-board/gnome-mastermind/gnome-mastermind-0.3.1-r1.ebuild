# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/gnome-mastermind/gnome-mastermind-0.3.1-r1.ebuild,v 1.5 2015/02/14 03:47:43 mr_bones_ Exp $

EAPI=5
GCONF_DEBUG="yes"

inherit autotools eutils gnome2

DESCRIPTION="A little Mastermind game for GNOME"
HOMEPAGE="http://www.autistici.org/gnome-mastermind/"
SRC_URI="http://download.gna.org/gnome-mastermind/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ppc x86"
IUSE=""

RDEPEND="
	gnome-base/gconf:2
	gnome-base/orbit
	app-text/gnome-doc-utils
	dev-libs/atk
	dev-libs/glib:2
	x11-libs/pango
	x11-libs/cairo
	x11-libs/gtk+:2
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-util/intltool
	sys-devel/gettext
	app-text/rarian
"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch

	# Fix .desktop file
	sed -i -e 's/True/true/' desktop/gnome-mastermind.desktop.in || die

	# Regenarate all intltool files to respect LINGUAS
	eautoreconf

	gnome2_src_prepare
}
