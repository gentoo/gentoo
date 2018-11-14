# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 flag-o-matic

MY_PV="${PV/_}"
MY_P="Soya-${MY_PV}"
TUT_P="SoyaTutorial-${MY_PV}"

DESCRIPTION="A high-level 3D engine for Python, designed with games in mind"
HOMEPAGE="http://oomadness.nekeme.net/Soya/FrontPage"
SRC_URI="
	http://download.gna.org/soya/${MY_P}.tar.bz2
	doc? ( http://download.gna.org/soya/${TUT_P}.tar.bz2 )
	examples? ( http://download.gna.org/soya/${TUT_P}.tar.bz2 )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc examples"

DEPEND="
	=dev-games/ode-0.11.1
	dev-python/editobj
	>=dev-python/pyopenal-0.1.6[${PYTHON_USEDEP}]
	media-fonts/freefonts
	media-libs/freetype:2
	>=media-libs/cal3d-0.10
	media-libs/freeglut
	>=media-libs/freetype-2.5
	>=media-libs/glew-1.3.3:*
	>=media-libs/libsdl-1.2.8[opengl]
	media-libs/openal
	virtual/opengl
	dev-python/pillow[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}/${P}-glu.patch"
	"${FILESDIR}/${PN}-pillow.patch"
)

python_compile() {
	local CFLAGS=${CFLAGS}
	append-cflags -fno-strict-aliasing
	distutils-r1_python_compile
}

python_install_all() {
	use doc && DOCS=( "${WORKDIR}/${TUT_P}/doc"/{soya_guide,pudding/pudding}.pdf )
	use examples && EXAMPLES=( "${WORKDIR}/${TUT_P}"/tutorial )

	distutils-r1_python_install_all
}
