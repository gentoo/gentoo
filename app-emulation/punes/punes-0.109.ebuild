# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools xdg-utils

DESCRIPTION="Nintendo Entertainment System (NES) emulator"
HOMEPAGE="https://github.com/punesemu/puNES"
SRC_URI="https://github.com/punesemu/puNES/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cg ffmpeg"

RDEPEND="
	ffmpeg? ( media-video/ffmpeg:= )
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	media-libs/alsa-lib
	virtual/glu
	virtual/opengl"
DEPEND="${RDEPEND}"
BDEPEND="
	cg? ( media-gfx/nvidia-cg-toolkit )
	dev-qt/linguist-tools:5
	dev-util/cmake
	virtual/pkgconfig"

S="${WORKDIR}/puNES-${PV}"

PATCHES=(
	"${FILESDIR}"/${P}_ldflags.patch
	"${FILESDIR}"/${P}_musl.patch # 830471
)

src_prepare() {
	default

	# src/extra/lib7zip is not autotools, but
	# is contained within AC_CONFIG_SUBDIRS
	AT_NO_RECURSIVE=1 eautoreconf
	cd src/extra/xdelta-3.1.0 || die
	eautoreconf
}

src_configure() {
	econf \
		$(use_with cg opengl-nvidia-cg) \
		$(use_with ffmpeg)
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
