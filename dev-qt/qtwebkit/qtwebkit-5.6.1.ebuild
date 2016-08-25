# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )
inherit python-any-r1 qt5-build

DESCRIPTION="WebKit rendering library for the Qt5 framework (deprecated)"
SRC_URI="https://download.qt.io/community_releases/${PV%.*}/${PV}/${PN}-opensource-src-${PV}.tar.xz"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm ~arm64 ppc64 x86"
fi

# TODO: qttestlib

IUSE="geolocation gstreamer gstreamer010 +jit multimedia opengl orientation printsupport qml webchannel webp"
REQUIRED_USE="?? ( gstreamer gstreamer010 multimedia )"

RDEPEND="
	dev-db/sqlite:3
	dev-libs/icu:=
	>=dev-libs/leveldb-1.18-r1
	dev-libs/libxml2:2
	dev-libs/libxslt
	~dev-qt/qtcore-${PV}[icu]
	~dev-qt/qtgui-${PV}
	~dev-qt/qtnetwork-${PV}
	~dev-qt/qtsql-${PV}
	~dev-qt/qtwidgets-${PV}
	media-libs/fontconfig:1.0
	media-libs/libpng:0=
	>=sys-libs/zlib-1.2.5
	virtual/jpeg:0
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXrender
	geolocation? ( ~dev-qt/qtpositioning-${PV} )
	gstreamer? (
		dev-libs/glib:2
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
	)
	gstreamer010? (
		dev-libs/glib:2
		media-libs/gstreamer:0.10
		media-libs/gst-plugins-base:0.10
	)
	multimedia? ( ~dev-qt/qtmultimedia-${PV}[widgets] )
	opengl? ( ~dev-qt/qtopengl-${PV} )
	orientation? ( ~dev-qt/qtsensors-${PV} )
	printsupport? ( ~dev-qt/qtprintsupport-${PV} )
	qml? ( ~dev-qt/qtdeclarative-${PV} )
	webchannel? ( ~dev-qt/qtwebchannel-${PV} )
	webp? ( media-libs/libwebp:0= )
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	dev-lang/ruby
	dev-util/gperf
	sys-devel/bison
	sys-devel/flex
	virtual/rubygems
"

PATCHES=(
	"${FILESDIR}/${PN}-5.4.2-system-leveldb.patch"
)

src_prepare() {
	# ensure bundled library cannot be used
	rm -r Source/ThirdParty/leveldb || die

	# bug 466216
	sed -i -e '/CONFIG +=/s/rpath//' \
		Source/WebKit/qt/declarative/{experimental/experimental,public}.pri \
		Tools/qmake/mkspecs/features/{force_static_libs_as_shared,unix/default_post}.prf \
		|| die

	qt_use_disable_mod geolocation positioning Tools/qmake/mkspecs/features/features.prf
	qt_use_disable_mod multimedia multimediawidgets Tools/qmake/mkspecs/features/features.prf
	qt_use_disable_mod orientation sensors Tools/qmake/mkspecs/features/features.prf
	qt_use_disable_mod printsupport printsupport Tools/qmake/mkspecs/features/features.prf
	qt_use_disable_mod qml quick Tools/qmake/mkspecs/features/features.prf
	qt_use_disable_mod webchannel webchannel \
		Source/WebKit2/Target.pri \
		Source/WebKit2/WebKit2.pri

	if use gstreamer010; then
		PATCHES+=("${FILESDIR}/${PN}-5.3.2-use-gstreamer010.patch")
	elif ! use gstreamer; then
		PATCHES+=("${FILESDIR}/${PN}-5.2.1-disable-gstreamer.patch")
	fi

	# bug 562396
	use jit || PATCHES+=("${FILESDIR}/${PN}-5.5.1-disable-jit.patch")

	use opengl || sed -i -e '/contains(QT_CONFIG, opengl): WEBKIT_CONFIG += use_3d_graphics/d' \
		Tools/qmake/mkspecs/features/features.prf || die
	use webp || sed -i -e '/config_libwebp: WEBKIT_CONFIG += use_webp/d' \
		Tools/qmake/mkspecs/features/features.prf || die

	# bug 458222
	sed -i -e '/SUBDIRS += examples/d' Source/QtWebKit.pro || die

	qt5-build_src_prepare
}
