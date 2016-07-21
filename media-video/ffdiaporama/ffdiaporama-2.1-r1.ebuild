# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils fdo-mime gnome2-utils qt4-r2

BIN_PV=${PV}.2014.0209
RSC_PV=${PV}.2014.0209
TMT_PV=1.0.2014.0125
OPENCLI_PV=0.18
OPENCLI_P=openclipart-${OPENCLI_PV}
DESCRIPTION="Movie creator from photos and video clips"
HOMEPAGE="http://ffdiaporama.tuxfamily.org"
SRC_URI="http://ffdiaporama.tuxfamily.org/script/GetPackage.php?f=${PN}_bin_${BIN_PV}.tar.gz -> ${PN}_bin_${BIN_PV}.tar.gz
	http://ffdiaporama.tuxfamily.org/script/GetPackage.php?f=${PN}_rsc_${RSC_PV}.tar.gz -> ${PN}_rsc_${RSC_PV}.tar.gz
	openclipart? ( http://openclipart.org/downloads/${OPENCLI_PV}/${OPENCLI_P}-svgonly.tar.bz2 )
	texturemate? ( http://ffdiaporama.tuxfamily.org/script/GetPackage.php?f=${PN}_texturemate_${TMT_PV}.tar.gz -> ${PN}_texturemate_${TMT_PV}.tar.gz )"

LICENSE="GPL-2
	openclipart? ( CC0-1.0 )
	texturemate? ( CC-BY-3.0 )"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="libav openclipart texturemate"

RDEPEND="
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qthelp:4
	dev-qt/qtsql:4[sqlite]
	dev-qt/qtsvg:4
	media-gfx/exiv2
	media-libs/libsdl[sound]
	media-libs/taglib
	!libav? ( >media-video/ffmpeg-1.2:0=[encode] )
	libav? ( >=media-video/libav-9:0=[encode] )"
DEPEND="${RDEPEND}"

DOCS=( authors.txt )
PATCHES=( "${FILESDIR}"/${P}-{ffmpeg-2.4,libav10}.patch )

S="${WORKDIR}/ffDiaporama"

src_prepare() {
	echo "SUBDIRS += ../ffDiaporama_rsc" >> ffDiaporama.pro || die
	if use texturemate; then
		echo "SUBDIRS += ../ffDiaporama_texturemate" >> ffDiaporama.pro || die
	fi
	qt4-r2_src_prepare
}

src_install() {
	qt4-r2_src_install
	doicon -s 32 ffdiaporama.png
	if use openclipart; then
		dodir /usr/share/ffDiaporama/clipart/openclipart
		cd "${WORKDIR}"/${OPENCLI_P}-svgonly/clipart || die
		find . -type d -maxdepth 1 -not -name . -exec cp -R '{}' "${D}"/usr/share/ffDiaporama/clipart/openclipart \; || die
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
