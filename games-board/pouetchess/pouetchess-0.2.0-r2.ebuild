# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils scons-utils toolchain-funcs

MY_PN=${PN/c/C}

DESCRIPTION="3D and open source chess game"
HOMEPAGE="http://pouetchess.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}_src_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug"

DEPEND="
	media-libs/libsdl:0[opengl,video]
	media-libs/sdl-image[jpeg,png]
	virtual/glu
	virtual/opengl"
RDEPEND=${DEPEND}

S=${WORKDIR}/${PN}_src_${PV}

PATCHES=(
	"${FILESDIR}"/${P}-sconstruct-sandbox.patch
	"${FILESDIR}"/${P}-nvidia_glext.patch
	"${FILESDIR}"/${P}-segfaults.patch
	"${FILESDIR}"/${P}-gcc43.patch
	"${FILESDIR}"/${P}-gcc6-cmath.patch
	# Fix for LibSDL >= 1.2.10 detection
	"${FILESDIR}"/${P}-fix-sdl-version-list.patch
)

src_configure() {
	tc-export CC CXX

	# turn off the hackish optimization setting code (bug #230127)
	scons configure \
		strip=false \
		optimize=false \
		prefix="${EPREFIX}"/usr \
		datadir="${EPREFIX}"/usr/share/${PN} \
		$(use debug && echo debug=1) || die
}

src_compile() {
	escons
}

src_install() {
	dobin bin/${MY_PN}

	insinto /usr/share/${PN}
	doins -r data/.

	einstalldocs

	doicon data/icons/${MY_PN}.png
	make_desktop_entry ${MY_PN} ${MY_PN} ${MY_PN} "KDE;Qt;Game;BoardGame"
}
