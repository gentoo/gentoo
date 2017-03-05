# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1 toolchain-funcs

DESCRIPTION="Fun 3D puzzle game using SDL/OpenGL"
HOMEPAGE="http://kiki.sourceforge.net/"
SRC_URI="mirror://sourceforge/kiki/${P}-src.tgz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	media-libs/libsdl[opengl]
	media-libs/sdl-image
	media-libs/sdl-mixer
	virtual/opengl
	virtual/glu
	media-libs/freeglut
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	dev-lang/swig"

S=${WORKDIR}/${PN}

PATCHES=(
	"${FILESDIR}"/${P}-gcc41.patch
	"${FILESDIR}"/${P}-freeglut.patch
	"${FILESDIR}"/${P}-gcc43.patch
	"${FILESDIR}"/${P}-build.patch
)

src_prepare() {
	default

	rm -f py/runkiki || die

	# Change the hard-coded data dir for sounds, etc...
	sed -i \
		-e "s:kiki_home += /;:kiki_home = /usr/share/${PN}/;:g" \
		-e "s:KConsole\:\:printf(\"WARNING \:\: environment variable KIKI_HOME not set ...\");::g" \
		-e "s:KConsole\:\:printf(\"           ... assuming resources in current directory\");::g" \
		src/main/KikiController.cpp || die

	# Bug 139570
	cd SWIG || die
	swig -c++ -python -globals kiki -o KikiPy_wrap.cpp KikiPy.i || die
	cp -f kiki.py ../py || die
	eapply "${FILESDIR}"/${P}-gcc46.patch
}

src_compile() {
	tc-export AR CXX

	emake -C kodilib/linux
	emake -C linux PYTHON_VERSION="${EPYTHON#python}"
}

src_install() {
	dobin linux/kiki

	insinto /usr/share/${PN}
	doins -r sound

	python_moduleinto ${PN}
	python_domodule py/.

	dodoc Readme.txt Thanks.txt
}
