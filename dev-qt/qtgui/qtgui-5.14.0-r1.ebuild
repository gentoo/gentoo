# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
QT5_MODULE="qtbase"
inherit qt5-build

DESCRIPTION="The GUI module and platform plugins for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
fi

# TODO: linuxfb

IUSE="accessibility dbus egl eglfs evdev +gif gles2 ibus
	jpeg +libinput +png tslib tuio +udev vnc wayland +xcb"
REQUIRED_USE="
	|| ( eglfs xcb )
	accessibility? ( dbus xcb )
	eglfs? ( egl )
	ibus? ( dbus )
	libinput? ( udev )
	xcb? ( gles2? ( egl ) )
"

COMMON_DEPEND="
	dev-libs/glib:2
	~dev-qt/qtcore-${PV}
	dev-util/gtk-update-icon-cache
	media-libs/fontconfig
	>=media-libs/freetype-2.6.1:2
	>=media-libs/harfbuzz-1.6.0:=
	sys-libs/zlib:=
	virtual/opengl
	dbus? ( ~dev-qt/qtdbus-${PV} )
	egl? ( media-libs/mesa[egl] )
	eglfs? (
		media-libs/mesa[gbm]
		x11-libs/libdrm
	)
	evdev? ( sys-libs/mtdev )
	gles2? ( media-libs/mesa[gles2] )
	jpeg? ( virtual/jpeg:0 )
	libinput? (
		dev-libs/libinput:=
		>=x11-libs/libxkbcommon-0.5.0
	)
	png? ( media-libs/libpng:0= )
	tslib? ( >=x11-libs/tslib-1.21 )
	tuio? ( ~dev-qt/qtnetwork-${PV} )
	udev? ( virtual/libudev:= )
	vnc? ( ~dev-qt/qtnetwork-${PV} )
	xcb? (
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libX11
		>=x11-libs/libxcb-1.12:=[xkb]
		>=x11-libs/libxkbcommon-0.5.0[X]
		x11-libs/xcb-util-image
		x11-libs/xcb-util-keysyms
		x11-libs/xcb-util-renderutil
		x11-libs/xcb-util-wm
	)
"
DEPEND="${COMMON_DEPEND}
	evdev? ( sys-kernel/linux-headers )
	udev? ( sys-kernel/linux-headers )
"
# bug 703306, _populate_Gui_plugin_properties breaks installed cmake modules
RDEPEND="${COMMON_DEPEND}
	!<dev-qt/qtimageformats-5.14.0:5
	!<dev-qt/qtsvg-5.14.0:5
	!<dev-qt/qtvirtualkeyboard-5.14.0:5
	!<dev-qt/qtwayland-5.14.0:5
"
PDEPEND="
	ibus? ( app-i18n/ibus )
	wayland? ( ~dev-qt/qtwayland-${PV} )
"

QT5_TARGET_SUBDIRS=(
	src/tools/qvkgen
	src/gui
	src/openglextensions
	src/platformheaders
	src/platformsupport
	src/plugins/generic
	src/plugins/imageformats
	src/plugins/platforms
	src/plugins/platforminputcontexts
)

QT5_GENTOO_CONFIG=(
	accessibility:accessibility-atspi-bridge
	egl:egl:
	eglfs:eglfs:
	eglfs:eglfs_egldevice:
	eglfs:eglfs_gbm:
	evdev:evdev:
	evdev:mtdev:
	:fontconfig:
	:system-freetype:FREETYPE
	!:no-freetype:
	!gif:no-gif:
	gles2::OPENGL_ES
	gles2:opengles2:OPENGL_ES_2
	!:no-gui:
	:system-harfbuzz:
	!:no-harfbuzz:
	jpeg:system-jpeg:IMAGEFORMAT_JPEG
	!jpeg:no-jpeg:
	libinput
	libinput:xkbcommon:
	:opengl
	png:png:
	png:system-png:IMAGEFORMAT_PNG
	!png:no-png:
	tslib:tslib:
	udev:libudev:
	xcb:xcb:
	xcb:xcb-glx:
	xcb:xcb-plugin:
	xcb:xcb-render:
	xcb:xcb-sm:
	xcb:xcb-xlib:
	xcb:xcb-xinput:
)

QT5_GENTOO_PRIVATE_CONFIG=(
	:gui
)

PATCHES=(
	"${FILESDIR}/qt-5.12-gcc-avx2.patch" # bug 672946
	"${FILESDIR}/${PN}-5.13.2-no-xcb-no-xkbcommon.patch" # bug 699110
)

src_prepare() {
	# don't add -O3 to CXXFLAGS, bug 549140
	sed -i -e '/CONFIG\s*+=/s/optimize_full//' src/gui/gui.pro || die

	# egl_x11 is activated when both egl and xcb are enabled
	use egl && QT5_GENTOO_CONFIG+=(xcb:egl_x11:) || QT5_GENTOO_CONFIG+=(egl:egl_x11:)

	qt_use_disable_config dbus dbus \
		src/platformsupport/themes/genericunix/genericunix.pri

	qt_use_disable_config tuio tuiotouch src/plugins/generic/generic.pro

	qt_use_disable_mod ibus dbus \
		src/plugins/platforminputcontexts/platforminputcontexts.pro

	use vnc || sed -i -e '/SUBDIRS += vnc/d' \
		src/plugins/platforms/platforms.pro || die

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
		-gui
		-system-harfbuzz
		$(qt_use jpeg libjpeg system)
		$(qt_use libinput)
		-opengl $(usex gles2 es2 desktop)
		$(qt_use png libpng system)
		$(qt_use tslib)
		$(qt_use udev libudev)
		$(qt_use xcb xcb system)
		$(usex xcb '-xcb-xlib -xcb-xinput -xkb' '')
	)
	if use libinput || use xcb; then
		myconf+=( -xkbcommon )
	fi
	qt5-build_src_configure
}
