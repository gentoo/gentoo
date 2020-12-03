# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

WX_GTK_VER="3.0-gtk3"
inherit cmake flag-o-matic wxwidgets

DESCRIPTION="OpenMW-specific fork of OpenSceneGraph"
HOMEPAGE="https://github.com/OpenMW/osg"
MY_COMMIT="8b07809fa674ecffe77338aaea2e223b3aadff0e"
SRC_URI="https://github.com/OpenMW/osg/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/osg-${MY_COMMIT}"

LICENSE="wxWinLL-3 LGPL-2.1"
SLOT="0/132" # NOTE: CHECK WHEN BUMPING! Subslot is SOVERSION
KEYWORDS="~amd64 ~x86"
IUSE="curl debug doc examples egl ffmpeg fltk fox gdal gif glut gstreamer jpeg
	lua openexr openinventor osgapps pdf png qt5 sdl sdl2 svg tiff
	truetype vnc wxwidgets xine xrandr zlib"

REQUIRED_USE="
	sdl2? ( sdl )
	openexr? ( zlib )
"

# TODO: COLLADA, FBX, GTA, OpenVRML, Performer, DCMTK
BDEPEND="
	app-arch/unzip
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"
RDEPEND="
	!dev-games/openscenegraph
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
	lua? ( >=dev-lang/lua-5.1.5:0= )
	openexr? (
		media-libs/ilmbase:=
		media-libs/openexr:=
	)
	openinventor? ( media-libs/coin )
	pdf? ( app-text/poppler[cairo] )
	png? ( media-libs/libpng:0= )
	qt5? (
		dev-qt/qtopengl:5
		dev-qt/qtwidgets:5
	)
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
	x11-base/xorg-proto
"

PATCHES=(
	"${FILESDIR}"/openscenegraph-3.4-cmake.patch
	"${FILESDIR}"/openscenegraph-3.5.1-jpeg-9.patch
	"${FILESDIR}"/openscenegraph-3.6.3-docdir.patch
)

src_prepare() {
	sed -i "s/ FIND_PACKAGE/ MACRO_OPTIONAL_FIND_PACKAGE/g" CMakeLists.txt || die "can't replace FIND_PACKAGE"
	cmake_src_prepare
}

src_configure() {
	if use examples && use wxwidgets; then
		setup-wxwidgets
	fi

	# Needed by FFmpeg
	append-cppflags -D__STDC_CONSTANT_MACROS

	local libdir=$(get_libdir)
	local mycmakeargs=(
		-DDYNAMIC_OPENSCENEGRAPH=ON
		-DLIB_POSTFIX=${libdir/lib}
		-DOPENGL_PROFILE=GL2 #GL1 GL2 GL3 GLES1 GLES3 GLES3
		-DOSG_PROVIDE_READFILE=ON
		-DOSG_USE_LOCAL_LUA_SOURCE=OFF
		-DWITH_Lua51=OFF # We use CMake-version FindLua52.cmake instead which can find any lua
		-DWITH_Lua52=$(usex lua)
		-DWITH_Asio=OFF # Fails to build, similar to https://github.com/chriskohlhoff/asio/issues/316
		-DWITH_CURL=$(usex curl)
		-DBUILD_DOCUMENTATION=$(usex doc)
		-DBUILD_OSG_APPLICATIONS=$(usex osgapps)
		-DBUILD_OSG_EXAMPLES=$(usex examples)
		-DWITH_FFmpeg=$(usex ffmpeg)
		-DWITH_GDAL=$(usex gdal)
		-DWITH_GIFLIB=$(usex gif)
		-DWITH_GStreamer=$(usex gstreamer)
		-DWITH_GLIB=$(usex gstreamer)
		-DWITH_GtkGl=OFF
		-DWITH_JPEG=$(usex jpeg)
		-DWITH_Jasper=OFF
		-DWITH_LIBLAS=OFF # dep failed to build https://bugs.gentoo.org/725938
		-DWITH_OpenEXR=$(usex openexr)
		-DWITH_Inventor=$(usex openinventor)
		-DWITH_Poppler-glib=$(usex pdf)
		-DWITH_PNG=$(usex png)
		-DWITH_SDL=$(usex sdl)
		-DWITH_SDL2=$(usex sdl2)
		-DWITH_RSVG=$(usex svg rsvg)
		-DWITH_TIFF=$(usex tiff)
		-DWITH_Freetype=$(usex truetype)
		-DWITH_LibVNCServer=$(usex vnc)
		-DWITH_Xine=$(usex xine)
		-DOSGVIEWER_USE_XRANDR=$(usex xrandr)
		-DWITH_ZLIB=$(usex zlib)
		-DOSG_USE_QT=$(usex qt5)
		-DDESIRED_QT_VERSION=5
	)
	if use examples; then
		mycmakeargs+=(
			-DWITH_FLTK=$(usex fltk)
			-DWITH_FOX=$(usex fox)
			-DWITH_GLUT=$(usex glut)
			-DWITH_wxWidgets=$(usex wxwidgets)
		)
	fi

	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	use doc && cmake_src_compile doc_openscenegraph doc_openthreads
}
