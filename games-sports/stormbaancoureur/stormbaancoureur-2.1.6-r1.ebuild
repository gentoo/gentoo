# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils

DESCRIPTION="Simulated obstacle course for automobiles"
HOMEPAGE="http://www.stolk.org/stormbaancoureur/"
SRC_URI="http://www.stolk.org/stormbaancoureur/download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="
	>=dev-games/ode-0.8
	media-libs/alsa-lib
	media-libs/freeglut
	>=media-libs/plib-1.8.4
	virtual/glu
	virtual/opengl"
RDEPEND=${DEPEND}

S=${WORKDIR}/${P}/src-${PN}

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
)

src_prepare() {
	default

	sed -ie "s:GENTOODIR:/usr/share/${PN}:" main.cxx || die
}

src_install() {
	dobin ${PN}
	insinto /usr/share/${PN}
	doins -r images/ models/ sounds/ shaders/
	dodoc JOYSTICKS README TODO
	make_desktop_entry ${PN} "Stormbaan Coureur"
}
