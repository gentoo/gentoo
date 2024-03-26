# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_IN_SOURCE_BUILD=1
inherit cmake desktop xdg

MY_PV="${PV//./_}"
MY_P="${PN}_${MY_PV}"

DESCRIPTION="GPS waypoints, tracks and routes converter"
HOMEPAGE="https://www.gpsbabel.org/ https://github.com/gpsbabel/gpsbabel"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/gpsbabel/gpsbabel.git"
else
	SRC_URI="https://github.com/gpsbabel/gpsbabel/archive/gpsbabel_${MY_PV}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~x86"
	S="${WORKDIR}/gpsbabel-gpsbabel_${MY_PV}"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="doc qt6"

BDEPEND="
	virtual/pkgconfig
	doc? (
		app-text/docbook-xml-dtd:4.1.2
		dev-lang/perl
		dev-libs/libxslt
	)
	!qt6? ( dev-qt/linguist-tools:5 )
	qt6? ( dev-qt/qttools:6[linguist] )
"

RDEPEND="
	dev-libs/expat
	sci-libs/shapelib:=
	sys-libs/zlib:=[minizip]
	virtual/libusb:1
	!qt6? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtserialport:5
		dev-qt/qtwebchannel:5
		dev-qt/qtwebengine:5[widgets]
		dev-qt/qtwidgets:5
		dev-qt/qtxml:5
	)
	qt6? (
		dev-qt/qtbase:6[gui,network,widgets,xml]
		dev-qt/qtserialport:6
		dev-qt/qtwebchannel:6
		dev-qt/qtwebengine:6[widgets]
		dev-qt/qt5compat:6
	)
"

DEPEND="${RDEPEND}"

DOCS=( AUTHORS NEWS README.{contrib,igc,md} gui/README.gui )

PATCHES=(
	"${FILESDIR}/${PN}-1.8.0-no-automagic-qt5-qt6.patch"
)

src_prepare() {
	cmake_src_prepare

	# ensure bundled libs are not used
	rm -r shapelib zlib || die
}

src_configure() {
	local mycmakeargs=(
		-DGPSBABEL_WITH_LIBUSB=pkgconfig
		-DGPSBABEL_WITH_SHAPELIB=pkgconfig
		-DGPSBABEL_WITH_ZLIB=pkgconfig
		-DGPSBABEL_MAPPREVIEW=ON
		-DGPSBABEL_EMBED_MAP=ON
		-DGPSBABEL_EMBED_TRANSLATIONS=ON
		-DUSE_QT6="$(usex qt6)"
	)

	cmake_src_configure
}

cmake_src_compile() {
	cmake_build gpsbabel
	cmake_build gpsbabelfe
	use doc && cmake_build gpsbabel.html
}

src_install() {
	use doc && dodoc gpsbabel.html
	einstalldocs

	dobin gpsbabel
	dobin gui/GPSBabelFE/gpsbabelfe
	insinto /usr/share/${PN}/translations/
	doins gui/gpsbabel*_*.qm
	newicon gui/images/appicon.png ${PN}.png
	domenu gui/gpsbabel.desktop
}
