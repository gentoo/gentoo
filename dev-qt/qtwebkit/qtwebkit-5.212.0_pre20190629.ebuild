# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
USE_RUBY="ruby24 ruby25 ruby26"
MY_P="${PN}-${PV/_pre20190629/-alpha3}" # present as upgrade over previous snapshot
inherit check-reqs cmake flag-o-matic python-any-r1 qmake-utils ruby-single toolchain-funcs

DESCRIPTION="WebKit rendering library for the Qt5 framework (deprecated)"
HOMEPAGE="https://www.qt.io/"
SRC_URI="https://github.com/annulen/webkit/releases/download/${MY_P}/${MY_P}.tar.xz"

LICENSE="BSD LGPL-2+"
SLOT="5/5.212"
KEYWORDS="amd64 arm arm64 ~ppc ppc64 x86"
IUSE="geolocation gles2 +gstreamer +hyphen +jit multimedia nsplugin opengl orientation +printsupport qml webp X"

REQUIRED_USE="
	nsplugin? ( X )
	qml? ( opengl )
	?? ( gstreamer multimedia )
"

# Dependencies found at Source/cmake/OptionsQt.cmake
QT_MIN_VER="5.9.1:5"
BDEPEND="
	${PYTHON_DEPS}
	${RUBY_DEPS}
	dev-lang/perl
	dev-util/gperf
	>=sys-devel/bison-2.4.3
	sys-devel/flex
	virtual/pkgconfig
"
DEPEND="
	dev-db/sqlite:3
	dev-libs/icu:=
	dev-libs/libxml2
	dev-libs/libxslt
	>=dev-qt/qtcore-${QT_MIN_VER}
	>=dev-qt/qtgui-${QT_MIN_VER}
	>=dev-qt/qtnetwork-${QT_MIN_VER}
	>=dev-qt/qtwidgets-${QT_MIN_VER}=
	media-libs/libpng:0=
	virtual/jpeg:0
	geolocation? ( >=dev-qt/qtpositioning-${QT_MIN_VER} )
	gstreamer? (
		dev-libs/glib:2
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-bad:1.0
		media-libs/gst-plugins-base:1.0
	)
	hyphen? ( dev-libs/hyphen )
	multimedia? ( >=dev-qt/qtmultimedia-${QT_MIN_VER}[widgets] )
	opengl? (
		>=dev-qt/qtgui-${QT_MIN_VER}[gles2=]
		>=dev-qt/qtopengl-${QT_MIN_VER}[gles2=]
	)
	orientation? ( >=dev-qt/qtsensors-${QT_MIN_VER} )
	printsupport? ( >=dev-qt/qtprintsupport-${QT_MIN_VER} )
	qml? (
		>=dev-qt/qtdeclarative-${QT_MIN_VER}
		>=dev-qt/qtwebchannel-${QT_MIN_VER}[qml]
	)
	webp? ( media-libs/libwebp:= )
	X? (
		x11-libs/libX11
		x11-libs/libXcomposite
		x11-libs/libXrender
	)
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

CHECKREQS_DISK_BUILD="16G" # bug 417307

PATCHES=( "${FILESDIR}/${P}-icu-65.patch" )

_check_reqs() {
	if [[ ${MERGE_TYPE} != binary ]] && is-flagq "-g*" && ! is-flagq "-g*0"; then
		einfo "Checking for sufficient disk space to build ${PN} with debugging flags"
		check-reqs_$1
	fi
}

pkg_pretend() {
	_check_reqs pkg_pretend
}

pkg_setup() {
	_check_reqs pkg_setup
	python-any-r1_pkg_setup
}

src_configure() {
	# Respect CC, otherwise fails on prefix, bug #395875
	tc-export CC

	# Multiple rendering bugs on youtube, github, etc without this, bug #547224
	append-flags $(test-flags -fno-strict-aliasing)

	local mycmakeargs=(
		-DPORT=Qt
		-DENABLE_API_TESTS=OFF
		-DENABLE_TOOLS=OFF
		-DENABLE_GEOLOCATION=$(usex geolocation)
		-DUSE_GSTREAMER=$(usex gstreamer)
		-DUSE_LIBHYPHEN=$(usex hyphen)
		-DENABLE_JIT=$(usex jit)
		-DUSE_QT_MULTIMEDIA=$(usex multimedia)
		-DENABLE_NETSCAPE_PLUGIN_API=$(usex nsplugin)
		-DENABLE_OPENGL=$(usex opengl)
		-DENABLE_PRINT_SUPPORT=$(usex printsupport)
		-DENABLE_DEVICE_ORIENTATION=$(usex orientation)
		-DENABLE_WEBKIT2=$(usex qml)
		$(cmake_use_find_package webp WebP)
		-DENABLE_X11_TARGET=$(usex X)
	)

	if has_version "virtual/rubygems[ruby_targets_ruby26]"; then
		mycmakeargs+=( -DRUBY_EXECUTABLE=$(type -P ruby26) )
	elif has_version "virtual/rubygems[ruby_targets_ruby25]"; then
		mycmakeargs+=( -DRUBY_EXECUTABLE=$(type -P ruby25) )
	else
		mycmakeargs+=( -DRUBY_EXECUTABLE=$(type -P ruby24) )
	fi

	cmake_src_configure
}

src_install() {
	cmake_src_install

	# bug 572056
	if [[ ! -f ${ED}$(qt5_get_libdir)/libQt5WebKit.so ]]; then
		eerror "${CATEGORY}/${PF} could not build due to a broken ruby environment."
		die 'Check "eselect ruby" and ensure you have a working ruby in your $PATH'
	fi
}
