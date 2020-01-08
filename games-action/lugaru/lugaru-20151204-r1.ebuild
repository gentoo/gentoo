# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake desktop

DESCRIPTION="3D arcade with unique fighting system and anthropomorphic characters"
HOMEPAGE="https://bitbucket.org/osslugaru/lugaru/wiki/Home"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2+ free-noncomm CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	media-libs/libpng:0=
	media-libs/libsdl:=[opengl,video]
	media-libs/libvorbis:=
	media-libs/openal:=
	sys-libs/zlib:=
	virtual/glu
	virtual/jpeg:0
	virtual/opengl"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-dir.patch
	"${FILESDIR}"/${P}-jpeg-9c.patch
)

src_prepare() {
	cmake_src_prepare

	sed -i \
		-e "s:@GENTOO_DIR@:/usr/share/${PN}:" \
		Source/OpenGL_Windows.cpp || die
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_VERBOSE_MAKEFILE=TRUE
		-DLUGARU_FORCE_INTERNAL_OPENGL=False
	)
	cmake_src_configure
}

src_install() {
	dobin "${BUILD_DIR}"/lugaru
	insinto /usr/share/${PN}
	doins -r Data
	newicon Source/win-res/Lugaru.png ${PN}.png
	make_desktop_entry ${PN} Lugaru ${PN}
}
