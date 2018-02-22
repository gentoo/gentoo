# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A 3D quaternionic fractal generator"
HOMEPAGE="http://www.physcip.uni-stuttgart.de/phy11733/quat_e.html"
SRC_URI="http://www.physcip.uni-stuttgart.de/phy11733/download/quat-1.20.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="X debug"

DEPEND="X? ( =x11-libs/fltk-1*
			x11-libs/libX11
			x11-libs/libXext
			x11-libs/libXft
		)
	>=sys-libs/zlib-1.1.4"
RDEPEND=""

src_configure() {
	export FLUID="/usr/bin/fluid" # needed because configure tries an invalid option
	econf \
		`use_enable X gui` \
		`use_enable debug` \
		`use_enable debug prof`
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog NEWS README
}
