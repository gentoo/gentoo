# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-qt/qtgui/qtgui-5.4.2.ebuild,v 1.1 2015/06/17 15:21:03 pesa Exp $

EAPI=5
QT5_MODULE="qtbase"
inherit qt5-build

DESCRIPTION="The GUI module and platform plugins for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc64 ~x86"
fi

# TODO: directfb, linuxfb, offscreen (auto-depends on X11)

IUSE="accessibility egl eglfs evdev +gif gles2 gtkstyle +harfbuzz ibus jpeg kms +png udev +xcb"
REQUIRED_USE="
	egl? ( evdev )
	eglfs? ( egl )
	kms? ( egl gles2 )
"

RDEPEND="
	dev-libs/glib:2
	~dev-qt/qtcore-${PV}
	media-libs/fontconfig
	media-libs/freetype:2
	>=sys-libs/zlib-1.2.5
	virtual/opengl
	egl? ( media-libs/mesa[egl] )
	evdev? ( sys-libs/mtdev )
	gtkstyle? (
		x11-libs/gtk+:2
		x11-libs/pango
		!!x11-libs/cairo[qt4]
	)
	gles2? ( media-libs/mesa[gles2] )
	harfbuzz? ( >=media-libs/harfbuzz-0.9.32:= )
	ibus? ( ~dev-qt/qtdbus-${PV} )
	jpeg? ( virtual/jpeg:0 )
	kms? (
		media-libs/mesa[gbm]
		virtual/libudev:=
		x11-libs/libdrm
	)
	png? ( media-libs/libpng:0= )
	udev? ( virtual/libudev:= )
	xcb? (
		x11-libs/libICE
		x11-libs/libSM
		>=x11-libs/libX11-1.5
		>=x11-libs/libXi-1.6
		x11-libs/libXrender
		>=x11-libs/libxcb-1.10:=[xkb]
		>=x11-libs/libxkbcommon-0.4.1[X]
		x11-libs/xcb-util-image
		x11-libs/xcb-util-keysyms
		x11-libs/xcb-util-renderutil
		x11-libs/xcb-util-wm
		accessibility? ( ~dev-qt/qtdbus-${PV} )
	)
"
DEPEND="${RDEPEND}
	evdev? ( sys-kernel/linux-headers )
	test? ( ~dev-qt/qtnetwork-${PV} )
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
)

QT5_GENTOO_CONFIG=(
	accessibility:accessibility-atspi-bridge
	egl
	eglfs
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
	harfbuzz:system-harfbuzz:HARFBUZZ
	!harfbuzz:no-harfbuzz:
	jpeg:system-jpeg:IMAGEFORMAT_JPEG
	!jpeg:no-jpeg:
	kms:kms:
	:opengl
	png:png:
	png:system-png:IMAGEFORMAT_PNG
	!png:no-png:
	udev:libudev:
	xcb:xcb:
	xcb:xcb-glx:
	xcb:xcb-plugin:
	xcb:xcb-render:
	xcb:xcb-sm:
	xcb:xcb-xlib:
	xcb:xinput2:
	xcb::XKB
)

pkg_setup() {
	use gtkstyle && QT5_TARGET_SUBDIRS+=(src/plugins/platformthemes/gtk2)
	use ibus     && QT5_TARGET_SUBDIRS+=(src/plugins/platforminputcontexts/ibus)
	use xcb	     && QT5_TARGET_SUBDIRS+=(src/plugins/platforminputcontexts/compose)

	# egl_x11 is activated when both egl and xcb are enabled
	use egl && QT5_GENTOO_CONFIG+=(xcb:egl_x11) || QT5_GENTOO_CONFIG+=(egl:egl_x11)
}

src_configure() {
	local myconf=(
		$(use accessibility && usex xcb -dbus-linked '')
		$(usex ibus -dbus-linked '')
		$(qt_use egl)
		$(qt_use eglfs)
		$(qt_use evdev)
		$(qt_use evdev mtdev)
		-fontconfig
		-system-freetype
		$(usex gif '' -no-gif)
		$(qt_use gtkstyle)
		$(qt_use harfbuzz harfbuzz system)
		$(qt_use jpeg libjpeg system)
		$(qt_use kms)
		-opengl $(usex gles2 es2 desktop)
		$(qt_use png libpng system)
		$(qt_use udev libudev)
		$(qt_use xcb xcb system)
		$(qt_use xcb xkbcommon system)
		$(use xcb && echo -xcb-xlib -xinput2 -xkb -xrender)
	)
	qt5-build_src_configure
}
