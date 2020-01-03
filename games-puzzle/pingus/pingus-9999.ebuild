# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake toolchain-funcs flag-o-matic xdg-utils

DESCRIPTION="free Lemmings clone"
HOMEPAGE="http://pingus.gitlab.io/"
if [[ "${PV}" == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/pingus/pingus.git"
else
	SRC_URI="https://github.com/Pingus/pingus/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi
LICENSE="GPL-3"
SLOT="0"
IUSE=""

RDEPEND="
	dev-libs/boost:=
	dev-libs/jsoncpp
	media-libs/libpng:0=
	media-libs/libsdl2[joystick,opengl,video]
	media-libs/sdl2-image[png]
	media-libs/sdl2-mixer[mod]
	virtual/opengl
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-0.7.6-noopengl.patch
	"${FILESDIR}"/${P}-no_libexec.patch
)

src_prepare() {
	sed '/find_package(Boost/s@ signals@@' -i CMakeLists.txt || die
	cmake_src_prepare
	strip-flags
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
