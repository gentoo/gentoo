# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop toolchain-funcs

DESCRIPTION="Simulated obstacle course for automobiles"
HOMEPAGE="https://www.stolk.org/stormbaancoureur/"
SRC_URI="https://www.stolk.org/stormbaancoureur/download/${P}.tar.gz"
S="${WORKDIR}/${P}/src-stormbaancoureur"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	>=dev-games/ode-0.8[-double-precision]
	media-libs/alsa-lib
	media-libs/freeglut
	>=media-libs/plib-1.8.4
	virtual/glu
	virtual/opengl"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${P}-clang.patch
)

src_prepare() {
	default

	sed -ie "s:GENTOODIR:/usr/share/${PN}:" main.cxx || die
}

src_compile() {
	tc-export CXX
	emake LIBDIRNAME=$(get_libdir)
}

src_install() {
	dobin ${PN}
	insinto /usr/share/${PN}
	doins -r images/ models/ sounds/ shaders/
	dodoc JOYSTICKS README TODO
	make_desktop_entry ${PN} "Stormbaan Coureur"
}
