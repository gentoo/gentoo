# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=(python2_7)

inherit distutils-r1 eutils

MY_PN="Soya"
MY_PV="${PV/_}"
MY_P="Soya-${MY_PV}"
TUT_P="SoyaTutorial-0.14"

DESCRIPTION="A high-level 3D engine for Python, designed with games in mind"
HOMEPAGE="http://home.gna.org/oomadness/en/soya3d/index.html"
SRC_URI="http://download.gna.org/soya/${MY_P}.tar.bz2
	doc? ( http://download.gna.org/soya/${TUT_P}.tar.bz2 )
	examples? ( http://download.gna.org/soya/${TUT_P}.tar.bz2 )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc examples"

RDEPEND=">=dev-games/ode-0.14[-double-precision]
	dev-python/editobj
	dev-python/pillow
	>=dev-python/pyopenal-0.1.6
	media-fonts/freefonts
	>=media-libs/cal3d-0.10
	media-libs/freeglut
	>=media-libs/freetype-2.1.5:2
	>=media-libs/glew-1.3.3:0
	>=media-libs/libsdl-1.2.8[opengl]
	media-libs/openal
	virtual/opengl
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_PN}"

PATCHES=(
	"${FILESDIR}/${P}-glu.patch"
)

src_unpack() {
	unpack ${A}
	mv "${WORKDIR}/${MY_P}" "${WORKDIR}/${MY_PN}"
}

src_install() {
	distutils-r1_src_install

	insinto /usr/share/${PF}
	if use doc; then
		cd "${WORKDIR}/${TUT_P}/doc"
		doins soya_guide.pdf pudding/pudding.pdf
	fi
	if use examples; then
		cd "${WORKDIR}/${TUT_P}"
		doins -r tutorial
	fi
}
