# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_KDEINSTALLDIRS=false
inherit ecm

DESCRIPTION="Simple but powerful Qt-based image viewer"
HOMEPAGE="https://photoqt.org/"
SRC_URI="https://photoqt.org/pkgs/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="devil exif freeimage graphicsmagick pdf raw"

BDEPEND="
	dev-qt/linguist-tools:5
"
RDEPEND="
	dev-qt/qtdeclarative:5
	dev-qt/qtgraphicaleffects:5
	dev-qt/qtgui:5
	dev-qt/qtimageformats:5
	dev-qt/qtmultimedia:5[qml]
	dev-qt/qtnetwork:5
	dev-qt/qtquickcontrols:5
	dev-qt/qtsql:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	app-arch/libarchive:=
	app-arch/unrar
	devil? ( media-libs/devil )
	exif? ( media-gfx/exiv2:= )
	freeimage? ( media-libs/freeimage )
	graphicsmagick? ( >=media-gfx/graphicsmagick-1.3.20:= )
	pdf? ( app-text/poppler[qt5] )
	raw? ( media-libs/libraw:= )
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-cmake.patch"
	"${FILESDIR}/${P}-exiv2-0.27.patch" # bugs 675714, 676194
)

src_configure() {
	local mycmakeargs=(
		-DDEVIL=$(usex devil)
		-DEXIV2=$(usex exif)
		-DFREEIMAGE=$(usex freeimage)
		-DGM=$(usex graphicsmagick)
		-DPOPPLER=$(usex pdf)
		-DRAW=$(usex raw)
	)
	ecm_src_configure
}
