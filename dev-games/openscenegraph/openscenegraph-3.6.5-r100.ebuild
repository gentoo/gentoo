# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1,2} )

MY_PN="OpenSceneGraph"
MY_P=${MY_PN}-${PV}
WX_GTK_VER="3.0-gtk3"
inherit cmake flag-o-matic lua-single wxwidgets

DESCRIPTION="Open source high performance 3D graphics toolkit"
HOMEPAGE="http://www.openscenegraph.org/"
SRC_URI="https://github.com/${PN}/${MY_PN}/archive/${MY_P}.tar.gz"

LICENSE="wxWinLL-3 LGPL-2.1"
SLOT="0/161" # NOTE: CHECK WHEN BUMPING! Subslot is SOVERSION
KEYWORDS="amd64 ~hppa ppc ppc64 x86"
IUSE="curl dicom debug doc egl examples ffmpeg fltk fox gdal gif glut
gstreamer jpeg las lua openexr openinventor osgapps pdf png sdl sdl2
svg tiff truetype vnc wxwidgets xrandr +zlib"

REQUIRED_USE="dicom? ( zlib )
	lua? ( ${LUA_REQUIRED_USE} )
	openexr? ( zlib )
	sdl2? ( sdl )"

# TODO: COLLADA, FBX, GTA, NVTT, OpenVRML, Performer
BDEPEND="
	app-arch/unzip
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"
RDEPEND="
	media-libs/mesa[egl?]
	virtual/glu
	virtual/opengl
	x11-libs/libSM
	x11-libs/libXext
	curl? ( net-misc/curl )
	examples? (
		fltk? ( x11-libs/fltk:1[opengl] )
		fox? ( x11-libs/fox:1.6[opengl] )
		glut? ( media-libs/freeglut )
		sdl2? ( media-libs/libsdl2 )
		wxwidgets? ( x11-libs/wxGTK:${WX_GTK_VER}[opengl,X] )
	)
	ffmpeg? ( media-video/ffmpeg:0= )
	gdal? ( sci-libs/gdal:= )
	gif? ( media-libs/giflib:= )
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
	)
	jpeg? ( virtual/jpeg:0 )
	las? ( >=sci-geosciences/liblas-1.8.0 )
	lua? ( ${LUA_DEPS} )
	openexr? (
		media-libs/ilmbase:=
		media-libs/openexr:=
	)
	openinventor? ( media-libs/coin )
	pdf? ( app-text/poppler[cairo] )
	png? ( media-libs/libpng:0= )
	sdl? ( media-libs/libsdl )
	svg? (
		gnome-base/librsvg
		x11-libs/cairo
	)
	tiff? ( media-libs/tiff:0 )
	truetype? ( media-libs/freetype:2 )
	vnc? ( net-libs/libvncserver )
	xrandr? ( x11-libs/libXrandr )
	zlib? ( sys-libs/zlib )
"
DEPEND="${RDEPEND}
	>=dev-libs/boost-1.37.0:*
	x11-base/xorg-proto
"

S="${WORKDIR}/${MY_PN}-${MY_P}"

PATCHES=(
	"${FILESDIR}"/${PN}-3.6.3-cmake.patch
	"${FILESDIR}"/${PN}-3.6.3-docdir.patch
	"${FILESDIR}"/${PN}-3.6.5-use_boost_asio.patch
	"${FILESDIR}"/${PN}-3.6.5-cmake_lua_version.patch
)

pkg_setup() {
	use lua && lua-single_pkg_setup
}

src_configure() {
	if use examples && use wxwidgets; then
		need-wxwidgets unicode
	fi

	# Needed by FFmpeg
	append-cppflags -D__STDC_CONSTANT_MACROS

	local libdir=$(get_libdir)
	local mycmakeargs=(
		-DDYNAMIC_OPENSCENEGRAPH=ON
		-DLIB_POSTFIX=${libdir/lib}
		-DOPENGL_PROFILE=GL2 #GL1 GL2 GL3 GLES1 GLES3 GLES3
		$(cmake_use_find_package curl CURL)
		-DBUILD_DOCUMENTATION=$(usex doc)
		$(cmake_use_find_package dicom DCMTK)
		$(cmake_use_find_package egl EGL)
		-DBUILD_OSG_EXAMPLES=$(usex examples)
		$(cmake_use_find_package ffmpeg FFmpeg)
		$(cmake_use_find_package gdal GDAL)
		$(cmake_use_find_package gif GIFLIB)
		$(cmake_use_find_package gstreamer GLIB)
		$(cmake_use_find_package gstreamer GStreamer)
		-DCMAKE_DISABLE_FIND_PACKAGE_GtkGl=ON
		$(cmake_use_find_package jpeg JPEG)
		-DCMAKE_DISABLE_FIND_PACKAGE_Jasper=ON
		$(cmake_use_find_package las LIBLAS)
		$(cmake_use_find_package lua Lua)
		-DCMAKE_DISABLE_FIND_PACKAGE_OpenCascade=ON
		$(cmake_use_find_package openexr OpenEXR)
		$(cmake_use_find_package openinventor Inventor)
		-DBUILD_OSG_APPLICATIONS=$(usex osgapps)
		$(cmake_use_find_package pdf Poppler-glib)
		$(cmake_use_find_package png PNG)
		$(cmake_use_find_package sdl SDL)
		$(cmake_use_find_package sdl2 SDL2)
		$(cmake_use_find_package svg RSVG)
		$(cmake_use_find_package tiff TIFF)
		$(cmake_use_find_package truetype Freetype)
		$(cmake_use_find_package vnc LibVNCServer)
		-DOSGVIEWER_USE_XRANDR=$(usex xrandr)
		$(cmake_use_find_package zlib ZLIB)
		-DOSG_USE_LOCAL_LUA_SOURCE=OFF
	)
	if use examples; then
		mycmakeargs+=(
			$(cmake_use_find_package fltk FLTK)
			$(cmake_use_find_package fox FOX)
			$(cmake_use_find_package glut GLUT)
			$(cmake_use_find_package wxwidgets wxWidgets)
		)
	fi
	if use lua; then
		mycmakeargs+=(
			-DLUA_VERSION="$(lua_get_version)"
		)
	fi

	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	use doc && cmake_src_compile doc_openscenegraph doc_openthreads
}
