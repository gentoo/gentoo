# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop toolchain-funcs

DESCRIPTION="A puzzle-solving, brain-stretching game for all ages"
HOMEPAGE="http://www.tuxradar.com/brainparty"
SRC_URI="https://launchpad.net/brainparty/trunk/${PV}/+download/${PN}${PV}.tar.gz"
S="${WORKDIR}"/${PN}

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-libs/libsdl[sound,opengl,video]
	media-libs/sdl-gfx
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-ttf
	virtual/opengl
	virtual/glu
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-savegame.patch
	"${FILESDIR}"/${P}-gcc49.patch
	"${FILESDIR}"/${P}-gnu_cxx-hash.patch
	"${FILESDIR}"/${P}-gcc-11.patch
	"${FILESDIR}"/${P}-clang-11.patch
)

src_prepare() {
	default

	sed -i \
		-e 's/$(LIBS) $(OSXCOMPAT) $(OBJFILES)/$(OSXCOMPAT) $(OBJFILES) $(LIBS)/' \
		-e 's/CXXFLAGS = .*/CXXFLAGS+=-c/' \
		-e '/^CXX =/d' \
		-e '/-o brainparty/s/INCLUDES) /&$(LDFLAGS) /' \
		Makefile || die
	sed -i \
		"/^int main(/ a\\\\tchdir(\"/usr/share/${PN}\");\n" \
		main.cpp || die

	tc-export CXX
}

src_install() {
	dobin brainparty

	insinto /usr/share/${PN}/Content
	doins -r Content/.

	newicon Content/icon.bmp ${PN}.bmp
	make_desktop_entry brainparty "Brain Party" /usr/share/pixmaps/${PN}.bmp
}
