# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools xdg-utils

DESCRIPTION="Nintendo Entertainment System (NES) emulator"
HOMEPAGE="https://github.com/punesemu/puNES"
SRC_URI="https://github.com/punesemu/puNES/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cg"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	media-libs/alsa-lib
	virtual/opengl"
DEPEND="${RDEPEND}"
BDEPEND="
	cg? ( media-gfx/nvidia-cg-toolkit )
	dev-qt/linguist-tools:5
	virtual/pkgconfig"

S="${WORKDIR}/puNES-${PV}"

src_prepare() {
	default

	sed -i "/update-desktop-database/d" misc/Makefile.am || die
	eautoreconf
	# FIXME why eautoreconf can't handle this?
	cd "src/extra/lib7zip-1.6.5" || die
	eautoreconf
}

src_configure() {
	econf \
		$(use_with cg opengl-nvidia-cg)
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
