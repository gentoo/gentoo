# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit qt5-build

DESCRIPTION="Qt module to support gamepad hardware"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm64 ~x86"
fi

IUSE="evdev qml sdl"

DEPEND="
	~dev-qt/qtcore-${PV}
	~dev-qt/qtgui-${PV}[evdev?]
	evdev? ( virtual/libudev:= )
	qml? ( ~dev-qt/qtdeclarative-${PV} )
	sdl? ( media-libs/libsdl )
"
RDEPEND="${DEPEND}"

src_prepare() {
	qt_use_disable_mod qml quick \
		src/src.pro

	qt_use_disable_config evdev evdev \
		src/plugins/gamepads/gamepads.pro

	qt_use_disable_config sdl sdl2 \
		src/plugins/gamepads/gamepads.pro

	qt5-build_src_prepare
}
