# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="command line tool to interact with an EWMH/NetWM compatible X Window Manager"
HOMEPAGE="http://tomas.styblo.name/wmctrl/"
SRC_URI="http://tomas.styblo.name/${PN}/dist/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86 ~x86-linux"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2:2
	x11-libs/libX11
	x11-libs/libXt
	x11-libs/libXmu"

DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	x11-proto/xproto"

PATCHES=( "${FILESDIR}/amd64-Xlib.patch" )

DOCS=( AUTHORS ChangeLog NEWS README )

src_install () {
	emake DESTDIR="${D}" install
	einstalldocs
}
