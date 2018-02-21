# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
WX_GTK_VER="3.0"

inherit cmake-utils flag-o-matic wxwidgets

MY_PN="OpenSceneGraph"
MY_P=${MY_PN}-${PV}

DESCRIPTION="Open source high performance 3D graphics toolkit"
HOMEPAGE="http://www.openscenegraph.org/"
SRC_URI="http://trac.openscenegraph.org/downloads/developer_releases/${MY_P}.zip"

LICENSE="wxWinLL-3 LGPL-2.1"
SLOT="0/35" # Subslot consists of major + minor version number
KEYWORDS="amd64 ~hppa ~ia64 ~ppc ~ppc64 x86"
IUSE="asio curl debug doc examples ffmpeg fltk fox gdal gif glut gstreamer gtk jpeg
jpeg2k las libav lua openexr openinventor osgapps pdf png qt5 sdl sdl2 svg tiff
truetype vnc wxwidgets xine xrandr zlib"

REQUIRED_USE="sdl2? ( sdl )"

# TODO: COLLADA, FBX, GTA, OpenVRML, Performer, DCMTK
RDEPEND="
	x11-libs/libSM
	x11-libs/libXext
	virtual/glu
	virtual/opengl
	asio? ( dev-cpp/asio )
	curl? ( net-misc/curl )
	examples? (
		fltk? ( x11-libs/fltk:1[opengl] )
		fox? ( x11-libs/fox:1.6[opengl] )
		glut? ( media-libs/freeglut )
		gtk? ( x11-libs/gtkglext )
		sdl2? ( media-libs/libsdl2 )
		wxwidgets? ( x11-libs/wxGTK:${WX_GTK_VER}[opengl,X] )
	)
	ffmpeg? (
		libav? ( media-video/libav:0= )
		!libav? ( media-video/ffmpeg:0= )
	)
	gdal? ( sci-libs/gdal )
	gif? ( media-libs/giflib:= )
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
	)
	jpeg? ( virtual/jpeg:0 )
	jpeg2k? ( media-libs/jasper:= )
	las? ( >=sci-geosciences/liblas-1.8.0 )
	lua? ( >=dev-lang/lua-5.1.5:* )
	openexr? (
		media-libs/ilmbase:=
		media-libs/openexr:=
	)
	openinventor? ( media-libs/coin )
	pdf? ( app-text/poppler[cairo] )
	png? ( media-libs/libpng:0= )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
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
	xine? ( media-libs/xine-lib )
	xrandr? ( x11-libs/libXrandr )
	zlib? ( sys-libs/zlib )
"
DEPEND="${RDEPEND}
	app-arch/unzip
	virtual/pkgconfig
	x11-proto/xextproto
	doc? ( app-doc/doxygen )
	xrandr? ( x11-proto/randrproto )
"

S="${WORKDIR}/${MY_P}"

DOCS=( AUTHORS.txt ChangeLog NEWS.txt )

PATCHES=(
	"${FILESDIR}"/${PN}-3.4.0-cmake.patch
	"${FILESDIR}"/${P}-ffmpeg-3.patch
	"${FILESDIR}"/${P}-jpeg-9.patch
)

src_configure() {
	if use examples && use wxwidgets; then
		need-wxwidgets unicode
	fi

	# Needed by FFmpeg
	append-cppflags -D__STDC_CONSTANT_MACROS

	local mycmakeargs=(
		-DDYNAMIC_OPENSCENEGRAPH=ON
		-DGENTOO_DOCDIR="/usr/share/doc/${PF}"
		-DOPENGL_PROFILE=GL2 #GL1 GL2 GL3 GLES1 GLES3 GLES3
		-DOSG_PROVIDE_READFILE=ON
		-DOSG_USE_LOCAL_LUA_SOURCE=OFF
		-DWITH_Lua51=OFF # We use CMake-version FindLua.cmake instead
		-DWITH_Asio=$(usex asio)
		-DWITH_CURL=$(usex curl)
		-DBUILD_DOCUMENTATION=$(usex doc)
		-DBUILD_OSG_APPLICATIONS=$(usex osgapps)
		-DBUILD_OSG_EXAMPLES=$(usex examples)
		-DWITH_FFmpeg=$(usex ffmpeg)
		-DWITH_GDAL=$(usex gdal)
		-DWITH_GIFLIB=$(usex gif)
		-DWITH_GStreamer=$(usex gstreamer)
		-DWITH_GLIB=$(usex gstreamer)
		-DWITH_GtkGl=$(usex gtk)
		-DWITH_JPEG=$(usex jpeg)
		-DWITH_Jasper=$(usex jpeg2k)
		-DWITH_LIBLAS=$(usex las)
		-DWITH_Lua=$(usex lua)
		-DWITH_OpenEXR=$(usex openexr)
		-DWITH_Inventor=$(usex openinventor)
		-DWITH_Poppler-glib=$(usex pdf)
		-DWITH_PNG=$(usex png)
		-DOSG_USE_QT=$(usex qt5)
		$(usex qt5 "-DDESIRED_QT_VERSION=5" "")
		-DWITH_SDL=$(usex sdl)
		-DWITH_SDL2=$(usex sdl2)
		-DWITH_RSVG=$(usex svg rsvg)
		-DWITH_TIFF=$(usex tiff)
		-DWITH_Freetype=$(usex truetype)
		-DWITH_LibVNCServer=$(usex vnc)
		-DWITH_Xine=$(usex xine)
		-DOSGVIEWER_USE_XRANDR=$(usex xrandr)
		-DWITH_ZLIB=$(usex zlib)
	)
	if use examples; then
		mycmakeargs+=(
			-DWITH_FLTK=$(usex fltk)
			-DWITH_FOX=$(usex fox)
			-DWITH_GLUT=$(usex glut)
			-DWITH_wxWidgets=$(usex wxwidgets)
		)
	fi

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	use doc && cmake-utils_src_compile doc_openscenegraph doc_openthreads
}
