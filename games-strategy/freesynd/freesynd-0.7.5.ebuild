# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_IN_SOURCE_BUILD=1
inherit cmake desktop xdg-utils readme.gentoo-r1

DESCRIPTION="Portable engine reimplementation for the classic Bullfrog game Syndicate"
HOMEPAGE="https://freesynd.sourceforge.io/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug devtools"

RDEPEND="
	media-libs/libogg
	media-libs/libpng:0=
	media-libs/libsdl[X,sound,video]
	media-libs/libvorbis
	media-libs/sdl-mixer[mp3,vorbis]
	media-libs/sdl-image[png]
"
DEPEND="${RDEPEND}"

DOCS=( NEWS README INSTALL AUTHORS )

PATCHES=( "${FILESDIR}"/${P}-cmake.patch )

DOC_CONTENTS="
	You have to set \"data_dir = /my/path/to/synd-data\"
	in \"~/.${PN}/${PN}.ini\".
"

src_prepare() {
	cmake_src_prepare

	sed -e "s:#freesynd_data_dir = /usr/share/freesynd/data:freesynd_data_dir = /usr/share/${PN}/data:" \
		-i ${PN}.ini || die
}

src_configure() {
	local mycmakeargs=(
		-DWITH_DEBUG=$(usex debug)
		-DBUILD_DEV_TOOLS=$(usex devtools)
	)
	cmake_src_configure
}

src_install() {
	dobin src/${PN}
	use devtools && newbin src/dump ${PN}-dump
	insinto /usr/share/${PN}
	doins -r data
	newicon -s 128 icon/sword.png ${PN}.png
	make_desktop_entry ${PN}
	einstalldocs
	readme.gentoo_create_doc
}

pkg_postinst() {
	xdg_icon_cache_update
	if use debug ; then
		ewarn "Debug build is not meant for regular playing,"
		ewarn "game speed is higher."
	fi
	readme.gentoo_print_elog
}

pkg_postrm() {
	xdg_icon_cache_update
}
