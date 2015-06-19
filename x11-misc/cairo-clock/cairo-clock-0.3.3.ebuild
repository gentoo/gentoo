# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/cairo-clock/cairo-clock-0.3.3.ebuild,v 1.8 2014/08/10 20:01:40 slyfox Exp $

EAPI=2

inherit autotools base

DESCRIPTION="An analog clock displaying the system-time"
HOMEPAGE="http://macslow.thepimp.net/?page_id=23"
SRC_URI="http://macslow.thepimp.net/projects/${PN}/${PN}_${PV}-1.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86 ~x86-fbsd"
IUSE=""
PATCHES=( "${FILESDIR}/${P}-gcc46.patch" )

RDEPEND="dev-libs/glib:2
	gnome-base/libglade
	gnome-base/librsvg
	>=x11-libs/cairo-1.2
	x11-libs/gtk+:2
	>=x11-libs/pango-1.10"
DEPEND="${DEPEND}
	virtual/pkgconfig
	dev-util/intltool
	sys-devel/gettext"

src_prepare() {
	base_src_prepare
	intltoolize --force --copy --automake || die "intltoolize failed"
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS BUGS ChangeLog NEWS README TODO
}
