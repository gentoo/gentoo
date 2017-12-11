# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit xdg-utils gnome2-utils qmake-utils

MY_PV=${PV%_pre20140701}
BIN_PV=${MY_PV}.devel.2014.0701
RSC_PV=${MY_PV}.devel.2014.0503
TMT_PV=1.0.2014.0125
DESCRIPTION="Movie creator from photos and video clips"
HOMEPAGE="http://ffdiaporama.tuxfamily.org"
SRC_URI="http://download.tuxfamily.org/${PN}/Packages/Devel/${PN}_bin_${BIN_PV}.tar.gz
	http://download.tuxfamily.org/${PN}/Packages/Devel/${PN}_rsc_${RSC_PV}.tar.gz
	https://dev.gentoo.org/~jstein/dist/ffdiaporama-2.2-libav11.patch
	https://dev.gentoo.org/~jstein/dist/ffdiaporama-2.2-ffmpeg-3.0.patch
	texturemate? ( http://download.tuxfamily.org/${PN}/Packages/Stable/${PN}_texturemate_${TMT_PV}.tar.gz )"

LICENSE="GPL-2
	texturemate? ( CC-BY-3.0 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libav openclipart qt5 texturemate"

RDEPEND="
	media-gfx/exiv2
	media-libs/taglib
	openclipart? ( media-gfx/openclipart[svg,-gzip] )
	qt5? (
		dev-qt/qtconcurrent:5
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qthelp:5
		dev-qt/qtmultimedia:5
		dev-qt/qtsql:5[sqlite]
		dev-qt/qtsvg:5
		dev-qt/qtxml:5
	)
	!qt5? (
		dev-qt/qtcore:4
		dev-qt/qtgui:4
		dev-qt/qthelp:4
		dev-qt/qtmultimedia:4
		dev-qt/qtsql:4[sqlite]
		dev-qt/qtsvg:4
	)
	libav? ( >=media-video/libav-11:0=[encode] )
	!libav? ( >=media-video/ffmpeg-2.8:0=[encode] )"
DEPEND="${RDEPEND}"

DOCS=( authors.txt )
PATCHES=( "${DISTDIR}"/${PN}-${MY_PV}-{ffmpeg-3.0,libav11}.patch "${FILESDIR}"/${PN}-${MY_PV}-qt4multimedia.patch )

S="${WORKDIR}/ffDiaporama"

src_prepare() {
	echo "SUBDIRS += ../ffDiaporama_rsc" >> ffDiaporama.pro || die
	if use texturemate; then
		echo "SUBDIRS += ../ffDiaporama_texturemate" >> ffDiaporama.pro || die
	fi
	default_src_prepare
}

src_configure() {
	use qt5 && eqmake5 QMAKE_CFLAGS_ISYSTEM=
	! use qt5 && eqmake4 QMAKE_CFLAGS_ISYSTEM=
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	if use openclipart; then
		dosym ../../clipart/openclipart /usr/share/ffDiaporama/clipart/openclipart
	fi
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_icon_cache_update
}
