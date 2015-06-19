# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/cairo-clock/cairo-clock-0.3.4.ebuild,v 1.3 2014/08/10 20:01:40 slyfox Exp $

EAPI=4

DESCRIPTION="An analog clock displaying the system-time"
HOMEPAGE="http://macslow.net/?page_id=23"
SRC_URI="http://macslow.thepimp.net/projects/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=dev-libs/glib-2.8
	>=gnome-base/libglade-2.6
	>=gnome-base/librsvg-2.14
	>=x11-libs/cairo-1.2
	>=x11-libs/gtk+-2.10:2
	>=x11-libs/pango-1.10"
DEPEND="${DEPEND}
	dev-util/intltool
	virtual/pkgconfig
	sys-devel/gettext"

DOCS=( AUTHORS NEWS README TODO )

src_prepare() {
	# cc: error: unrecognized option '--export-dynamic'
	sed -i -e '/cairo_clock_LDFLAGS/s:=.*:= -rdynamic:' src/Makefile.in || die
}
