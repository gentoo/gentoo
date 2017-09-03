# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ ${PV} = *9999 ]]; then
	GITECLASS="git-r3"
	EGIT_REPO_URI="https://github.com/${PN}-cms/${PN}.git"
fi
inherit cmake-multilib flag-o-matic ${GITECLASS}
unset GITECLASS

DESCRIPTION="Colour management system allowing to share settings across apps and services"
HOMEPAGE="http://www.oyranos.org/"
[[ ${PV} != *9999 ]] && \
SRC_URI="https://github.com/${PN}-cms/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~asturm/${P}-patches.tar.xz"

KEYWORDS="~amd64 ~x86"
LICENSE="BSD"
SLOT="0"
IUSE="X cairo cups doc examples exif fltk jpeg qt5 raw scanner static-libs test tiff"

REQUIRED_USE="qt5? ( X ) test? ( static-libs )"

#OY_LINGUAS="cs;de;eo;eu;fr;ru" #TODO

COMMON_DEPEND="
	>=app-admin/elektra-0.8.4:0[${MULTILIB_USEDEP}]
	dev-libs/libxml2[${MULTILIB_USEDEP}]
	>=dev-libs/yajl-2.0.4-r1[${MULTILIB_USEDEP}]
	media-libs/lcms:2[${MULTILIB_USEDEP}]
	media-libs/libpng:0=[${MULTILIB_USEDEP}]
	>=media-libs/libXcm-0.5.4[${MULTILIB_USEDEP}]
	media-libs/openicc[${MULTILIB_USEDEP}]
	cairo? ( x11-libs/cairo[${MULTILIB_USEDEP}] )
	cups? ( net-print/cups[${MULTILIB_USEDEP}] )
	exif? ( media-gfx/exiv2:=[${MULTILIB_USEDEP}] )
	fltk? ( x11-libs/fltk:1 )
	jpeg? ( virtual/jpeg:0[${MULTILIB_USEDEP}] )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtsvg:5
		dev-qt/qtwidgets:5
		dev-qt/qtx11extras:5
		dev-qt/qtxml:5
	)
	raw? ( media-libs/libraw[${MULTILIB_USEDEP}] )
	scanner? ( media-gfx/sane-backends[${MULTILIB_USEDEP}] )
	tiff? ( media-libs/tiff:0[${MULTILIB_USEDEP}] )
	X? (
		x11-libs/libX11[${MULTILIB_USEDEP}]
		x11-libs/libXfixes[${MULTILIB_USEDEP}]
		x11-libs/libXinerama[${MULTILIB_USEDEP}]
		x11-libs/libXmu[${MULTILIB_USEDEP}]
		x11-libs/libXrandr[${MULTILIB_USEDEP}]
		x11-libs/libXxf86vm[${MULTILIB_USEDEP}]
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

MULTILIB_CHOST_TOOLS=(
	/usr/bin/oyranos-config
)
MULTILIB_WRAPPED_HEADERS=(
	/usr/include/oyranos/oyranos_version.h
)

CMAKE_REMOVE_MODULES_LIST="${CMAKE_REMOVE_MODULES_LIST} FindXcm FindCUPS"

PATCHES=( "${WORKDIR}/patches" )

src_prepare() {
	einfo remove bundled libs
	rm -r libxcm openicc yajl || die
	cmake-utils_src_prepare
}

multilib_src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_DOCDIR=share/doc/${PF}
		-DUSE_SYSTEM_ELEKTRA=ON
		-DUSE_SYSTEM_LIBXCM=ON
		-DUSE_SYSTEM_OPENICC=ON
		-DUSE_SYSTEM_YAJL=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt4=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_Cairo=$(usex '!cairo')
		-DCMAKE_DISABLE_FIND_PACKAGE_Cups=$(usex '!cups')
		-DCMAKE_DISABLE_FIND_PACKAGE_Doxygen=$(multilib_native_usex doc OFF ON)
		-DENABLE_EXAMPLES=$(usex examples)
		-DCMAKE_DISABLE_FIND_PACKAGE_Exif2=$(usex '!exif')
		-DCMAKE_DISABLE_FIND_PACKAGE_FLTK=$(multilib_native_usex fltk OFF ON)
		-DCMAKE_DISABLE_FIND_PACKAGE_JPEG=$(usex '!jpeg')
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5=$(multilib_native_usex qt5 OFF ON)
		-DCMAKE_DISABLE_FIND_PACKAGE_LibRaw=$(usex '!raw')
		-DCMAKE_DISABLE_FIND_PACKAGE_Sane=$(usex '!scanner')
		-DENABLE_STATIC_LIBS=$(usex static-libs)
		-DENABLE_TESTS=$(usex test)
		-DCMAKE_DISABLE_FIND_PACKAGE_TIFF=$(usex '!tiff')
		-DCMAKE_DISABLE_FIND_PACKAGE_X11=$(usex '!X')
	)

	cmake-utils_src_configure
}
