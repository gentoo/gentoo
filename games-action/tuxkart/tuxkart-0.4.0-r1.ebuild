# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="A racing game starring Tux, the Linux penguin"
HOMEPAGE="http://tuxkart.sourceforge.net/"
SRC_URI="mirror://sourceforge/tuxkart/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~x86"
IUSE=""

RDEPEND=">=media-libs/plib-1.8.0
	x11-libs/libX11
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXmu
	virtual/opengl"
DEPEND="${RDEPEND}
	x11-libs/libXt"

src_prepare() {
	default

	# apparently <sys/perm.h> doesn't exist on alpha
	if use alpha; then
		sed -i \
			-e '/#include <sys\/perm.h>/d' src/gfx.cxx || die
	fi
	sed -i \
		-e "/^plib_suffix/ s/-lplibul/-lplibul -lplibjs/" \
		-e "s/-malign-double//; s/-O6//" configure || die
	sed -i \
		-e "/^bindir/s/=.*/=@bindir@/" src/Makefile.in || die
}

src_install() {
	default
	dodoc doc/*.html
	rm -rf "${D}/usr/share/tuxkart/" || die
}
