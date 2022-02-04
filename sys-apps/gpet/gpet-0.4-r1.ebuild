# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="GTK+ based TOMOYO policy editor"
HOMEPAGE="http://en.sourceforge.jp/projects/gpet/"
SRC_URI="mirror://sourceforge.jp/gpet/53178/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	gnome-base/gconf
	sys-devel/gettext
	x11-libs/cairo
	x11-libs/gtk+:2
	x11-libs/pango"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/intltool
	virtual/pkgconfig"

src_prepare() {
	default

	sed -i -e "/^gpetdocdir =/s!doc/gpet!doc/${PF}!" Makefile.am || die
	eautoreconf
}
