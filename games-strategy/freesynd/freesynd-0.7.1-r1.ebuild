# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils cmake-utils gnome2-utils readme.gentoo-r1

DESCRIPTION="A portable reimplementation of engine for the classic Bullfrog game, Syndicate"
HOMEPAGE="http://freesynd.sourceforge.net/"
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

PATCHES=( "${FILESDIR}"/${P}-cmake.patch )

CMAKE_IN_SOURCE_BUILD=1

DOC_CONTENTS="
	You have to set \"data_dir = /my/path/to/synd-data\"
	in \"~/.${PN}/${PN}.ini\".
"

src_prepare() {
	cmake-utils_src_prepare

	sed \
		-e "s:#freesynd_data_dir = /usr/share/freesynd/data:freesynd_data_dir = /usr/share/${PN}/data:" \
		-i ${PN}.ini || die
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with debug DEBUG)
		$(cmake-utils_use_build devtools DEV_TOOLS)
	)

	cmake-utils_src_configure
}

src_install() {
	dobin src/${PN}
	use devtools && newbin src/dump ${PN}-dump
	insinto /usr/share/${PN}
	doins -r data
	newicon -s 128 icon/sword.png ${PN}.png
	make_desktop_entry ${PN}
	dodoc NEWS README INSTALL AUTHORS
	readme.gentoo_create_doc
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	if use debug ; then
		ewarn "Debug build is not meant for regular playing,"
		ewarn "game speed is higher."
	fi
	readme.gentoo_print_elog
}

pkg_postrm() {
	gnome2_icon_cache_update
}
