# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools xdg-utils

DESCRIPTION="Nintendo Entertainment System (NES) emulator"
HOMEPAGE="https://github.com/punesemu/puNES"
SRC_URI="https://github.com/punesemu/puNES/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cg"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	cg? ( media-gfx/nvidia-cg-toolkit )
	media-libs/alsa-lib
	media-libs/libsdl[opengl]
	virtual/opengl"

DEPEND="
	${RDEPEND}
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
		--enable-qt5 \
		$(use_with cg opengl-nvidia-cg)
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
