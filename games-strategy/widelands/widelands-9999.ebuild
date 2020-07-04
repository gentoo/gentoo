# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit cmake python-any-r1 xdg

MY_PV="build$(ver_cut 2-)"
MY_P="${PN}-${MY_PV/_/-}"

DESCRIPTION="A game similar to Settlers 2"
HOMEPAGE="https://www.widelands.org/"

if [[ "${PV}" == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/widelands/widelands.git"
else
	SRC_URI="https://launchpad.net/widelands/build$(ver_cut 2)/${MY_PV/_/-}/+download/${MY_P}.tar.bz2"
	S="${WORKDIR}/${MY_P}"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2+"
SLOT="0"
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
	dev-lang/lua:0
"
BDEPEND="
	sys-devel/gettext
"

CMAKE_BUILD_TYPE="Release"

PATCHES=(
	"${FILESDIR}/${PN}-0.20_rc1-cxxflags.patch"
)

src_prepare() {
	cmake_src_prepare

	sed -i -e 's:__ppc__:__PPC__:' src/map_io/s2map.cc || die
	# don't call gtk-update-icon-cache
	sed '/^find_program(GTK_UPDATE_ICON_CACHE/d' \
		-i xdg/CMakeLists.txt || die
}

src_configure() {
	local WLDIR="${EPREFIX}/usr/share/${PN}"
	local mycmakeargs=(
		-DOPTION_BUILD_WEBSITE_TOOLS=OFF

		# -DUSE_XDG=ON breaks finding of datadir
		-DUSE_XDG=OFF

		# Upstream's cmake files are totally fscked up...
		# This just helps dealing with less crap in src_install
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		-DWL_INSTALL_BASEDIR="${WLDIR}"
		-DWL_INSTALL_DATADIR="${WLDIR}/data"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	# upstream CMakeLists.txt file is totally bonkers
	local sharedir="${ED}/usr/share"
	dodir /usr/bin
	mv "${ED}"/usr/${PN} "${ED}"/usr/bin || die
	mv "${ED}"/share/* "${sharedir}" || die
	rmdir "${ED}"/share || die
	rm "${sharedir}"/${PN}/{COPYING,CREDITS,ChangeLog} || die
	mv "${sharedir}"/${PN}/VERSION "${sharedir}"/doc/${PF}/ || die

	#newicon data/images/logos/wl-ico-128.png ${PN}.png
	#make_desktop_entry ${PN} ${PN^}
}
