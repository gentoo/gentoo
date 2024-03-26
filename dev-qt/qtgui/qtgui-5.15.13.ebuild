# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} != *9999* ]]; then
	QT5_KDEPATCHSET_REV=1
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

QT5_MODULE="qtbase"
inherit qt5-build

DESCRIPTION="The GUI module and platform plugins for the Qt5 framework"

SLOT=5/${QT5_PV} # bug 707658
IUSE="accessibility dbus egl eglfs evdev gles2-only ibus jpeg +libinput
	linuxfb +png tslib tuio +udev vnc vulkan wayland +X"
REQUIRED_USE="
	|| ( eglfs linuxfb vnc wayland X )
	accessibility? ( dbus X )
	eglfs? ( egl )
	ibus? ( dbus )
	libinput? ( udev )
	X? ( gles2-only? ( egl ) )
"

RDEPEND="
	dev-libs/glib:2
	=dev-qt/qtcore-${QT5_PV}*:5=
	dev-util/gtk-update-icon-cache
	media-libs/fontconfig
	media-libs/freetype:2
	media-libs/harfbuzz:=
	sys-libs/zlib:=
	accessibility? ( app-accessibility/at-spi2-core:2 )
	dbus? ( =dev-qt/qtdbus-${QT5_PV}* )
	eglfs? (
		media-libs/mesa[gbm(+)]
		x11-libs/libdrm
	)
	evdev? ( sys-libs/mtdev )
	jpeg? ( media-libs/libjpeg-turbo:= )
	gles2-only? ( media-libs/libglvnd )
	!gles2-only? ( media-libs/libglvnd[X] )
	libinput? (
		dev-libs/libinput:=
		x11-libs/libxkbcommon
	)
	png? ( media-libs/libpng:= )
	tslib? ( >=x11-libs/tslib-1.21 )
	tuio? ( =dev-qt/qtnetwork-${QT5_PV}* )
	udev? ( virtual/libudev:= )
	vnc? ( =dev-qt/qtnetwork-${QT5_PV}* )
	vulkan? ( dev-util/vulkan-headers )
	X? (
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libX11
		x11-libs/libxcb:=
		x11-libs/libxkbcommon[X]
		x11-libs/xcb-util-image
		x11-libs/xcb-util-keysyms
		x11-libs/xcb-util-renderutil
		x11-libs/xcb-util-wm
	)
"
DEPEND="${RDEPEND}
	evdev? ( sys-kernel/linux-headers )
	linuxfb? ( sys-kernel/linux-headers )
	udev? ( sys-kernel/linux-headers )
	X? ( x11-base/xorg-proto )
"
PDEPEND="
	ibus? ( app-i18n/ibus )
	wayland? ( =dev-qt/qtwayland-${QT5_PV}* )
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
	gles2-only::OPENGL_ES
	gles2-only:opengles2:OPENGL_ES_2
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
	vulkan:vulkan:
	X:xcb:
	X:xcb-glx:
	X:xcb-plugin:
	X:xcb-render:
	X:xcb-sm:
	X:xcb-xlib:
	X:xcb-xinput:
)

QT5_GENTOO_PRIVATE_CONFIG=(
	:gui
)

src_prepare() {
	# don't add -O3 to CXXFLAGS, bug 549140
	sed -i -e '/CONFIG\s*+=/s/optimize_full//' src/gui/gui.pro || die

	# egl_x11 is activated when both egl and X are enabled
	use egl && QT5_GENTOO_CONFIG+=(X:egl_x11:) || QT5_GENTOO_CONFIG+=(egl:egl_x11:)

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
		$(qt_use accessibility feature-accessibility-atspi-bridge)
		$(usev dbus -dbus-linked)
		$(qt_use egl)
		$(qt_use eglfs)
		$(usev eglfs '-gbm -kms')
		$(qt_use evdev)
		$(qt_use evdev mtdev)
		-fontconfig
		-system-freetype
		-gui
		-system-harfbuzz
		$(qt_use jpeg libjpeg system)
		$(qt_use libinput)
		$(qt_use linuxfb)
		-opengl $(usex gles2-only es2 desktop)
		$(qt_use png libpng system)
		$(qt_use tslib)
		$(qt_use udev libudev)
		$(qt_use vulkan)
		$(qt_use X xcb)
		$(usev X '-xcb-xlib')
	)
	if use libinput || use X; then
		myconf+=( -xkbcommon )
	fi
	qt5-build_src_configure
}
