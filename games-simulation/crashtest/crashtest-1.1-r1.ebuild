# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils flag-o-matic

DESCRIPTION="Educational car crash simulator"
HOMEPAGE="http://www.stolk.org/crashtest/"
SRC_URI="http://www.stolk.org/crashtest/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-games/ode
	media-libs/alsa-lib
	media-libs/freeglut
	x11-libs/fltk:1[opengl]
	virtual/opengl
	virtual/glu"
DEPEND="${RDEPEND}
	>=media-libs/plib-1.8.4"

S=${WORKDIR}/${P}/src-${PN}

PATCHES=(
	"${FILESDIR}/${P}"-gentoo.patch
)

src_prepare() {
	default

	sed -i \
		-e "s:@GENTOO_DATADIR@:/usr/share/${PN}:" \
		-e "s:@GENTOO_BINDIR@:/usr/bin:" \
		Makefile ${PN}.cxx || die
	append-cppflags -DHAVE_ISNANF
}

src_install() {
	default
	make_desktop_entry ${PN} Crashtest
}
