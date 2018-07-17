# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit qt5-build

DESCRIPTION="Wayland platform plugin for Qt"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86"
fi

IUSE="+libinput xcomposite"

DEPEND="
	>=dev-libs/wayland-1.6.0
	~dev-qt/qtcore-${PV}
	~dev-qt/qtdeclarative-${PV}
	~dev-qt/qtgui-${PV}[egl,libinput?]
	media-libs/mesa[egl]
	>=x11-libs/libxkbcommon-0.2.0
	xcomposite? (
		x11-libs/libX11
		x11-libs/libXcomposite
	)
"
RDEPEND="${DEPEND}"

src_prepare() {
	qt_use_disable_config libinput xkbcommon-evdev \
		src/client/client.pro \
		src/compositor/wayland_wrapper/wayland_wrapper.pri \
		src/plugins/shellintegration/ivi-shell/ivi-shell.pro \
		tests/auto/compositor/compositor/compositor.pro

	use xcomposite || rm -r config.tests/xcomposite || die

	qt5-build_src_prepare
}
