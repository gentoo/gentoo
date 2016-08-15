# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
QT5_MODULE="qtbase"
inherit qt5-build

DESCRIPTION="The GUI module and platform plugins for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~arm64 hppa ~ppc ppc64 x86"
fi

# TODO: linuxfb

IUSE="accessibility dbus egl eglfs evdev +gif gles2 gtkstyle
	ibus jpeg libinput +png tslib tuio +udev +xcb"
REQUIRED_USE="
	|| ( eglfs xcb )
	accessibility? ( dbus xcb )
	eglfs? ( egl )
	ibus? ( dbus )
	libinput? ( udev )
	xcb? ( gles2? ( egl ) )
"

RDEPEND="
	dev-libs/glib:2
	~dev-qt/qtcore-${PV}
	media-libs/fontconfig
	>=media-libs/freetype-2.6.1:2
	>=media-libs/harfbuzz-1.0.6:=
	>=sys-libs/zlib-1.2.5
	virtual/opengl
	dbus? ( ~dev-qt/qtdbus-${PV} )
	egl? ( media-libs/mesa[egl] )
	eglfs? (
		media-libs/mesa[gbm]
		x11-libs/libdrm
	)
	evdev? ( sys-libs/mtdev )
	gtkstyle? (
		x11-libs/gtk+:2
		x11-libs/pango
		!!x11-libs/cairo[qt4]
	)
	gles2? ( media-libs/mesa[gles2] )
	jpeg? ( virtual/jpeg:0 )
	libinput? (
		dev-libs/libinput:=
		x11-libs/libxkbcommon
	)
	png? ( media-libs/libpng:0= )
	tslib? ( x11-libs/tslib )
	tuio? ( ~dev-qt/qtnetwork-${PV} )
	udev? ( virtual/libudev:= )
	xcb? (
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libX11
		>=x11-libs/libXi-1.7.4
		x11-libs/libXrender
		>=x11-libs/libxcb-1.10:=[xkb]
		>=x11-libs/libxkbcommon-0.4.1[X]
		x11-libs/xcb-util-image
		x11-libs/xcb-util-keysyms
		x11-libs/xcb-util-renderutil
		x11-libs/xcb-util-wm
	)
"
DEPEND="${RDEPEND}
	evdev? ( sys-kernel/linux-headers )
	udev? ( sys-kernel/linux-headers )
"
PDEPEND="
	ibus? ( app-i18n/ibus )
"

QT5_TARGET_SUBDIRS=(
	src/gui
	src/openglextensions
	src/platformheaders
	src/platformsupport
	src/plugins/generic
	src/plugins/imageformats
	src/plugins/platforms
	src/plugins/platforminputcontexts
	src/plugins/platformthemes
)

QT5_GENTOO_CONFIG=(
	accessibility:accessibility-atspi-bridge
	egl
	eglfs
	eglfs:eglfs_egldevice:
	eglfs:eglfs_gbm:
	evdev
	evdev:mtdev:
	:fontconfig
	:system-freetype:FREETYPE
	!:no-freetype:
	!gif:no-gif:
	gles2::OPENGL_ES
	gles2:opengles2:OPENGL_ES_2
	gtkstyle:gtkstyle:
	gtkstyle:gtk2:STYLE_GTK
	!:no-gui:
	:system-harfbuzz:HARFBUZZ
	!:no-harfbuzz:
	jpeg:system-jpeg:IMAGEFORMAT_JPEG
	!jpeg:no-jpeg:
	libinput
	libinput:xkbcommon-evdev:
	:opengl
	png:png:
	png:system-png:IMAGEFORMAT_PNG
	!png:no-png:
	tslib
	udev:libudev:
	xcb:xcb:
	xcb:xcb-glx:
	xcb:xcb-plugin:
	xcb:xcb-render:
	xcb:xcb-sm:
	xcb:xcb-xlib:
	xcb:xinput2:
	xcb::XKB
	xcb:xrender
)

src_prepare() {
	# egl_x11 is activated when both egl and xcb are enabled
	use egl && QT5_GENTOO_CONFIG+=(xcb:egl_x11) || QT5_GENTOO_CONFIG+=(egl:egl_x11)

	# avoid automagic dep on qtdbus
	use dbus || sed -i -e 's/contains(QT_CONFIG, dbus)/false/' \
		src/platformsupport/platformsupport.pro || die

	qt_use_disable_mod ibus dbus \
		src/plugins/platforminputcontexts/platforminputcontexts.pro

	# avoid automagic dep on qtnetwork
	use tuio || sed -i -e '/SUBDIRS += tuiotouch/d' \
		src/plugins/generic/generic.pro || die

	qt5-build_src_prepare
}

src_configure() {
	local myconf=(
		$(usex dbus -dbus-linked '')
		$(qt_use egl)
		$(qt_use eglfs)
		$(usex eglfs '-gbm -kms' '')
		$(qt_use evdev)
		$(qt_use evdev mtdev)
		-fontconfig
		-system-freetype
		$(usex gif '' -no-gif)
		$(qt_use gtkstyle)
		-system-harfbuzz
		$(qt_use jpeg libjpeg system)
		$(qt_use libinput)
		$(qt_use libinput xkbcommon-evdev)
		-opengl $(usex gles2 es2 desktop)
		$(qt_use png libpng system)
		$(qt_use tslib)
		$(qt_use udev libudev)
		$(qt_use xcb xcb system)
		$(qt_use xcb xkbcommon-x11 system)
		$(usex xcb '-xcb-xlib -xinput2 -xkb -xrender' '')
	)
	qt5-build_src_configure
}
