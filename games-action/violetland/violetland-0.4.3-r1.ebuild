# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils cmake-utils

DESCRIPTION="Help a girl named Violet in the struggle with hordes of monsters"
HOMEPAGE="https://violetland.github.io/"
SRC_URI="https://github.com/ooxi/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3 CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-libs/boost:=[threads(+)]
	media-libs/libsdl[sound,video]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-ttf
	virtual/glu
	virtual/opengl"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-boost150.patch )

src_prepare() {
	cmake-utils_src_prepare

	sed -i \
		-e "/README_EN.TXT/d" \
		-e "/README_RU.TXT/d" \
		CMakeLists.txt || die "sed failed"
	rm README_RU.TXT || die
}

src_configure() {
	local mycmakeargs=(
		-DDATA_INSTALL_DIR=share/${PN}
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	newicon icon-light.png ${PN}.png
	make_desktop_entry ${PN} VioletLand
}
