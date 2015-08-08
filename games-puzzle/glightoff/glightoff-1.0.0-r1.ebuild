# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
GCONF_DEBUG="yes"

inherit eutils gnome2

DESCRIPTION="A simple (but not so easy to solve!) puzzle game"
HOMEPAGE="http://glightoff.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

RDEPEND="
	gnome-base/librsvg
	media-libs/libpng:0=
	>=x11-libs/gtk+-2.6:2
"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.29
	virtual/pkgconfig
"

src_prepare() {
	# Fix broken png files
	pngfix -q --out=out.png glightoff.png
	mv -f out.png glightoff.png || die

	epatch "${FILESDIR}/${PN}-1.0.0-desktop.patch"

	gnome2_src_prepare
}
