# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CMAKE_MIN_VERSION="3.9.0"

inherit cmake-utils eutils

DESCRIPTION="Lightweight osu! port"
HOMEPAGE="https://github.com/fmang/oshu"
SRC_URI="https://www.mg0.fr/oshu/releases/${P}.tar.gz
	osu-skin? ( https://www.mg0.fr/oshu/skins/osu-v1.tar.gz -> ${PN}-skin-v1.tar.gz )"

KEYWORDS="~amd64 ~x86"
LICENSE="GPL-3 CC-BY-NC-4.0"
SLOT="0"
IUSE="libav osu-skin"

RDEPEND="
	>=media-libs/libsdl2-2.0.5:=
	media-libs/sdl2-image:=
	x11-libs/cairo:=
	x11-libs/pango:=
	!libav? ( media-video/ffmpeg:= )
	libav? ( media-video/libav:= )
"

DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

RESTRICT="test"

src_prepare() {
	if use osu-skin; then
		epatch "${FILESDIR}/oshu-2.0.0-use_unpacked_osu-skin.patch"
		mv "${WORKDIR}/osu" share/skins/
	fi

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		'-DOSHU_DEFAULT_SKIN='$(usex osu-skin 'osu' 'minimal')
		'-DOSHU_SKINS=minimal'$(usex osu-skin ';osu' '')
	)

	cmake-utils_src_configure
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
