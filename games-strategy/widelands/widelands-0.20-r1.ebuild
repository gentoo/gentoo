# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit desktop cmake python-any-r1

MY_PV="build$(ver_cut 2-)"
MY_P="${PN}-${MY_PV/_/-}"

DESCRIPTION="A game similar to Settlers 2"
HOMEPAGE="https://www.widelands.org/"
SRC_URI="https://launchpad.net/widelands/build$(ver_cut 2)/${MY_PV/_/-}/+download/${MY_P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-libs/boost-1.48:=
	dev-libs/icu:=
	media-libs/glew:0=
	media-libs/libglvnd
	media-libs/libpng:0=
	media-libs/libsdl2[video]
	media-libs/sdl2-image[jpeg,png]
	media-libs/sdl2-mixer[vorbis]
	media-libs/sdl2-ttf
	sys-libs/zlib:=[minizip]"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
"
BDEPEND="
	sys-devel/gettext
"

CMAKE_BUILD_TYPE="Release"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.20_rc1-cxxflags.patch
	"${FILESDIR}"/${PN}-0.20-glvnd.patch
	"${FILESDIR}"/${PN}-0.20-boost-1.73.patch
)

src_prepare() {
	cmake_src_prepare

	sed -i -e 's:__ppc__:__PPC__:' src/map_io/s2map.cc || die
}

src_configure() {
	local mycmakeargs=(
		-DOPTION_BUILD_WEBSITE_TOOLS=OFF

		# Upstream's cmake files are totally fscked up...
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}"/usr/share/doc/${PF}
		# Game is NOT happy being moved from /usr/share/games
		-DWL_INSTALL_DATADIR="${EPREFIX}"/usr/share/games/${PN}
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	# move game binary to correct location
	dodir /usr/bin
	mv "${ED}"/usr/share/doc/${PF}/${PN} "${ED}"/usr/bin || die

	newicon data/images/logos/wl-ico-128.png ${PN}.png
	make_desktop_entry ${PN} ${PN^}
}
