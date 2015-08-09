# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 flag-o-matic

MY_PV="${PV/_}"
MY_P="Soya-${MY_PV}"
TUT_P="SoyaTutorial-${MY_PV}"

DESCRIPTION="A high-level 3D engine for Python, designed with games in mind"
HOMEPAGE="http://oomadness.nekeme.net/Soya/FrontPage"
SRC_URI="http://download.gna.org/soya/${MY_P}.tar.bz2
	doc? ( http://download.gna.org/soya/${TUT_P}.tar.bz2 )
	examples? ( http://download.gna.org/soya/${TUT_P}.tar.bz2 )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="doc examples"

DEPEND="=dev-games/ode-0.11.1
	dev-python/editobj
	virtual/python-imaging[${PYTHON_USEDEP}]
	>=dev-python/pyopenal-0.1.6[${PYTHON_USEDEP}]
	media-fonts/freefonts
	>=media-libs/cal3d-0.10
	media-libs/freeglut
	>=media-libs/freetype-2.5
	>=media-libs/glew-1.3.3
	>=media-libs/libsdl-1.2.8[opengl]
	media-libs/openal
	virtual/opengl"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}/${P}-glu.patch"
	"${FILESDIR}/${PN}-pillow.patch"
	"${FILESDIR}/${P}-freetype-2.5.patch"
)

python_compile() {
	local CFLAGS=${CFLAGS}
	append-cflags -fno-strict-aliasing
	distutils-r1_python_compile
}

python_install_all() {
	distutils-r1_python_install_all

	insinto /usr/share/${PF}
	if use doc; then
		cd "${WORKDIR}/${TUT_P}/doc"
		doins soya_guide.pdf pudding/pudding.pdf || die "doins failed"
	fi
	if use examples; then
		cd "${WORKDIR}/${TUT_P}"
		doins -r tutorial || die "doins failed"
	fi
}
