# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils fdo-mime gnome2-utils qt4-r2

OPENCLI_PV=0.18
OPENCLI_P=openclipart-${OPENCLI_PV}
TEXTUREMATE_P=ffDiaporama-texturemate_1.0
DESCRIPTION="Movie creator from photos and video clips"
HOMEPAGE="http://ffdiaporama.tuxfamily.org"
SRC_URI="http://download.tuxfamily.org/${PN}/Archives/${PN}_${PV}.tar.gz
	openclipart? ( http://openclipart.org/downloads/${OPENCLI_PV}/${OPENCLI_P}-svgonly.tar.bz2 )
	texturemate? ( http://download.tuxfamily.org/${PN}/Archives/${TEXTUREMATE_P}.tar.gz )"

LICENSE="GPL-2
	openclipart? ( CC0-1.0 )
	texturemate? ( CC-BY-3.0 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="openclipart texturemate"

RDEPEND="
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qthelp:4
	dev-qt/qtsql:4[sqlite]
	dev-qt/qtsvg:4
	media-gfx/exiv2
	media-libs/libsdl[sound]
	media-libs/taglib
	!<media-video/ffmpeg-1.2:0
	virtual/ffmpeg[encode]"
DEPEND="${RDEPEND}"

DOCS=( authors.txt )

S="${WORKDIR}"

src_configure() {
	eqmake4 ffDiaporama.pro
	qt4-r2_src_configure
}

src_install() {
	qt4-r2_src_install
	doicon -s 32 ffdiaporama.png
	if use openclipart; then
		dodir /usr/share/ffDiaporama/clipart/openclipart
		cd "${S}"/${OPENCLI_P}-svgonly/clipart || die
		find . -type d -maxdepth 1 -not -name . -exec cp -R '{}' "${D}"/usr/share/ffDiaporama/clipart/openclipart \; || die
	fi
	if use texturemate; then
		cd "${S}"/ffDiaporama-texturemate || die
		./install.sh "${D}"/usr
	fi
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}
