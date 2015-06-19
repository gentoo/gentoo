# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/viewer/viewer-0.8.0.ebuild,v 1.5 2012/03/17 11:07:42 pacho Exp $

EAPI="2"

inherit autotools multilib

DESCRIPTION="A stereo pair image viewer (supports ppm's only)"
HOMEPAGE="http://www-users.cs.umn.edu/~wburdick/geowall/viewer.html"
SRC_URI="ftp://ftp.cs.umn.edu/dept/users/wburdick/geowall/${P}.tar.gz"
SRC_URI="http://www-users.cs.umn.edu/~wburdick/ftp/geowall/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""
DEPEND="virtual/opengl
	media-libs/freeglut
	x11-libs/libXmu
	x11-libs/libXt
	x11-libs/libICE
	x11-libs/libSM"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i configure.in \
		-e "s|/usr/X11R6/lib|/usr/$(get_libdir)/X11|g" \
		-e 's|/usr/X11R6/include|/usr/include/X11|g'
	eautoreconf
}

src_compile() {
	emake LDFLAGS="${LDFLAGS}" CFLAGS="${CFLAGS}" || die "emake failed"
}

src_install() {
	dobin viewer
	doman viewer.1

	dodoc AUTHORS ChangeLog README
}
