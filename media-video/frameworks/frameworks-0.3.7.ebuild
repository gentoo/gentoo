# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/frameworks/frameworks-0.3.7.ebuild,v 1.4 2014/08/10 20:59:15 slyfox Exp $

EAPI=2

DESCRIPTION="A small v4l frame capture utility especially suited for stop motion animation"
SRC_URI="http://frameworks.polycrystal.org/release/${P}.tar.gz"
HOMEPAGE="http://frameworks.polycrystal.org"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~ppc ~x86 ~amd64"
IUSE=""

RDEPEND=">=gnome-base/libglade-2
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_install () {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README TODO
}
