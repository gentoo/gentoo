# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils cmake-utils mercurial

EHG_REPO_URI="https://bitbucket.org/osslugaru/lugaru/"
DESCRIPTION="3D arcade with unique fighting system and anthropomorphic characters"
HOMEPAGE="https://bitbucket.org/osslugaru/lugaru/wiki/Home"
SRC_URI=""

LICENSE="GPL-2+ free-noncomm CC-BY-SA-3.0"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	media-libs/libsdl[opengl,video]
	media-libs/libpng:0
	media-libs/libvorbis
	media-libs/openal
	sys-libs/zlib
	virtual/glu
	virtual/jpeg:0
	virtual/opengl"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_unpack() {
	mercurial_src_unpack
}

PATCHES=(
	"${FILESDIR}/${P}-dir.patch"
)

src_prepare() {
	default
	sed -i \
        -e "s:@GENTOO_DIR@:/usr/share/${PN}:" \
        Source/OpenGL_Windows.cpp || die
}

src_configure() {
	mycmakeargs=(
		"-DCMAKE_VERBOSE_MAKEFILE=TRUE"
		"-DLUGARU_FORCE_INTERNAL_OPENGL=False"
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	dobin "${WORKDIR}/${P}_build/lugaru"
	insinto /usr/share/${PN}
	doins -r Data/
	newicon Source/win-res/Lugaru.png ${PN}.png
	make_desktop_entry ${PN} Lugaru ${PN}
}
