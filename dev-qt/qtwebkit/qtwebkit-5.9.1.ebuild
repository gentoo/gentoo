# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )
QT_MIN_VER="5.9.1:5"
inherit python-any-r1 qt5-build

DESCRIPTION="WebKit rendering library for the Qt5 framework (deprecated)"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ppc64 x86"
fi

# TODO: qttestlib

IUSE="geolocation gstreamer gles2 +jit multimedia opengl orientation printsupport qml test webchannel webp"
REQUIRED_USE="?? ( gstreamer multimedia )"

RDEPEND="
	dev-db/sqlite:3
	dev-libs/icu:=
	>=dev-libs/leveldb-1.18-r1
	dev-libs/libxml2:2
	dev-libs/libxslt
	>=dev-qt/qtcore-${QT_MIN_VER}[icu]
	>=dev-qt/qtgui-${QT_MIN_VER}
	>=dev-qt/qtnetwork-${QT_MIN_VER}
	>=dev-qt/qtsql-${QT_MIN_VER}
	>=dev-qt/qtwidgets-${QT_MIN_VER}
	media-libs/fontconfig:1.0
	media-libs/libpng:0=
	>=sys-libs/zlib-1.2.5
	virtual/jpeg:0
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXrender
	geolocation? ( >=dev-qt/qtpositioning-${QT_MIN_VER} )
	gstreamer? (
		dev-libs/glib:2
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
	)
	multimedia? ( >=dev-qt/qtmultimedia-${QT_MIN_VER}[widgets] )
	opengl? (
		>=dev-qt/qtgui-${QT_MIN_VER}[gles2=]
		>=dev-qt/qtopengl-${QT_MIN_VER}
	)
	orientation? ( >=dev-qt/qtsensors-${QT_MIN_VER} )
	printsupport? ( >=dev-qt/qtprintsupport-${QT_MIN_VER} )
	qml? ( >=dev-qt/qtdeclarative-${QT_MIN_VER} )
	webchannel? ( >=dev-qt/qtwebchannel-${QT_MIN_VER} )
	webp? ( media-libs/libwebp:0= )
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	dev-lang/ruby
	dev-util/gperf
	sys-devel/bison
	sys-devel/flex
	virtual/rubygems
	test? ( >=dev-qt/qttest-${QT_MIN_VER} )
"

PATCHES=(
	"${FILESDIR}/${PN}-5.4.2-system-leveldb.patch"
)

src_prepare() {
	# ensure bundled library cannot be used
	rm -r Source/ThirdParty/leveldb || die

	# force using system library
	sed -i -e 's/qtConfig(system-jpeg)/true/' \
		-e 's/qtConfig(system-png)/true/' \
		Tools/qmake/mkspecs/features/features.prf || die

	# bug 466216
	sed -i -e '/CONFIG +=/s/rpath//' \
		Source/WebKit/qt/declarative/{experimental/experimental,public}.pri \
		Tools/qmake/mkspecs/features/{force_static_libs_as_shared,unix/default_post}.prf \
		|| die

	qt_use_disable_config opengl opengl Tools/qmake/mkspecs/features/features.prf

	qt_use_disable_mod geolocation positioning Tools/qmake/mkspecs/features/features.prf
	qt_use_disable_mod multimedia multimediawidgets Tools/qmake/mkspecs/features/features.prf
	qt_use_disable_mod orientation sensors Tools/qmake/mkspecs/features/features.prf
	qt_use_disable_mod printsupport printsupport Tools/qmake/mkspecs/features/features.prf
	qt_use_disable_mod qml quick Tools/qmake/mkspecs/features/features.prf
	qt_use_disable_mod webchannel webchannel \
		Source/WebKit2/Target.pri \
		Source/WebKit2/WebKit2.pri

	if ! use gstreamer; then
		PATCHES+=("${FILESDIR}/${PN}-5.8.0-disable-gstreamer.patch")
	fi

	# bug 562396
	use jit || PATCHES+=("${FILESDIR}/${PN}-5.5.1-disable-jit.patch")

	use webp || sed -i -e '/config_libwebp: WEBKIT_CONFIG += use_webp/d' \
		Tools/qmake/mkspecs/features/features.prf || die

	# bug 458222
	sed -i -e '/SUBDIRS += examples/d' Source/QtWebKit.pro || die

	qt5-build_src_prepare
}

src_install() {
	qt5-build_src_install

	# bug 572056
	if [[ ! -f ${D%/}${QT5_LIBDIR}/libQt5WebKit.so ]]; then
		eerror "${CATEGORY}/${PF} could not build due to a broken ruby environment."
		die 'Check "eselect ruby" and ensure you have a working ruby in your $PATH'
	fi
}
