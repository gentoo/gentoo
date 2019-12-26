# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ ${PV} = *9999 ]]; then
	EGIT_REPO_URI="https://github.com/${PN}-cms/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/${PN}-cms/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
		https://dev.gentoo.org/~asturm/${P}-patches.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi
CMAKE_REMOVE_MODULES_LIST="${CMAKE_REMOVE_MODULES_LIST} FindXcm FindCUPS"
inherit cmake-utils flag-o-matic xdg

DESCRIPTION="Colour management system allowing to share settings across apps and services"
HOMEPAGE="https://www.oyranos.org/"

LICENSE="BSD"
SLOT="0"
IUSE="cairo cups doc examples exif fltk jpeg qt5 raw scanner static-libs test tiff X"

REQUIRED_USE="qt5? ( X ) test? ( static-libs )"

COMMON_DEPEND="
	app-admin/elektra
	dev-libs/libxml2
	>=dev-libs/yajl-2.0.4-r1
	media-libs/lcms:2
	media-libs/libpng:0=
	>=media-libs/libXcm-0.5.4
	media-libs/openicc
	cairo? ( x11-libs/cairo )
	cups? ( net-print/cups )
	exif? ( media-gfx/exiv2:= )
	fltk? ( x11-libs/fltk:1 )
	jpeg? ( virtual/jpeg:0 )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtsvg:5
		dev-qt/qtwidgets:5
		dev-qt/qtx11extras:5
		dev-qt/qtxml:5
	)
	raw? ( media-libs/libraw )
	scanner? ( media-gfx/sane-backends )
	tiff? ( media-libs/tiff:0 )
	X? (
		x11-libs/libX11
		x11-libs/libXfixes
		x11-libs/libXinerama
		x11-libs/libXmu
		x11-libs/libXrandr
		x11-libs/libXxf86vm
	)
"
DEPEND="${COMMON_DEPEND}
	doc? (
		app-doc/doxygen
		media-gfx/graphviz
	)"
RDEPEND="${COMMON_DEPEND}
	media-libs/icc-profiles-basiccolor-printing2009
	media-libs/icc-profiles-openicc"

DOCS=( {AUTHORS,ChangeLog,README}.md )

RESTRICT="test"

PATCHES=(
	"${WORKDIR}/patches"
	"${FILESDIR}/${P}-mesa-18.3.1.patch" # bug 671996
	"${FILESDIR}/${P}-underlinking.patch"
)

src_prepare() {
	# remove bundled libs
	rm -r libxcm openicc yajl || die
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_DOCDIR=share/doc/${PF}
		-DUSE_SYSTEM_ELEKTRA=ON
		-DUSE_SYSTEM_LIBXCM=ON
		-DUSE_SYSTEM_OPENICC=ON
		-DUSE_SYSTEM_YAJL=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt4=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_Cairo=$(usex !cairo)
		-DCMAKE_DISABLE_FIND_PACKAGE_Cups=$(usex !cups)
		-DCMAKE_DISABLE_FIND_PACKAGE_Doxygen=$(usex !doc)
		-DENABLE_EXAMPLES=$(usex examples)
		-DCMAKE_DISABLE_FIND_PACKAGE_Exif2=$(usex !exif)
		-DCMAKE_DISABLE_FIND_PACKAGE_FLTK=$(usex !fltk)
		-DCMAKE_DISABLE_FIND_PACKAGE_JPEG=$(usex !jpeg)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5=$(usex !qt5)
		-DCMAKE_DISABLE_FIND_PACKAGE_LibRaw=$(usex !raw)
		-DCMAKE_DISABLE_FIND_PACKAGE_Sane=$(usex !scanner)
		-DENABLE_STATIC_LIBS=$(usex static-libs)
		-DENABLE_TESTS=$(usex test)
		-DCMAKE_DISABLE_FIND_PACKAGE_TIFF=$(usex !tiff)
		-DCMAKE_DISABLE_FIND_PACKAGE_X11=$(usex !X)
	)

	cmake-utils_src_configure
}
