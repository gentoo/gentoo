# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/epplets/epplets-0.14.ebuild,v 1.1 2012/11/08 03:18:53 vapier Exp $

EAPI="4"

DESCRIPTION="Base files for Enlightenment epplets and some epplets"
HOMEPAGE="http://www.enlightenment.org/"
SRC_URI="mirror://sourceforge/enlightenment/epplets-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~x86"
IUSE="static-libs"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	media-libs/freeglut
	media-libs/imlib2
	>=x11-wm/enlightenment-0.16.4"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	x11-proto/xproto
	x11-proto/xextproto"

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	use static-libs || find "${ED}"/usr -name '*.la' -delete
}
