# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="First Tux shooter multi-player network game inspired by Bulanci"
HOMEPAGE="https://repo.or.cz/w/tuxanci.git"
SRC_URI="mirror://gentoo/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="dedicated opengl physfs"

RDEPEND="
	!dedicated? (
		media-libs/fontconfig
		media-libs/libsdl[opengl?,sound,video]
		media-libs/sdl-image[png]
		media-libs/sdl-mixer[vorbis]
		media-libs/sdl-ttf
		opengl? ( virtual/opengl )
	)
	physfs? ( dev-games/physfs[zip] )
	!physfs? ( dev-libs/libzip:= )"
DEPEND="${RDEPEND}"
BDEPEND="sys-devel/gettext"

PATCHES=(
	"${FILESDIR}"/${P}-no-glver.patch
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_SERVER=$(usex dedicated)
		-DCMAKE_CONF_PATH="${EPREFIX}"/etc
		-DCMAKE_DOC_PATH="${EPREFIX}"/usr/share/doc/${PF}
		-DENABLE_DEBUG=no
		-DWITH_OPENGL=$(usex opengl)
		-DWITH_PHYSFS=$(usex physfs)
	)
	cmake_src_configure
}
