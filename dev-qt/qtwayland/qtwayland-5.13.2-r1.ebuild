# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit qt5-build

DESCRIPTION="Wayland platform plugin for Qt"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm arm64 ~hppa ~ppc ppc64 ~x86"
fi

IUSE="+libinput xcomposite"

DEPEND="
	>=dev-libs/wayland-1.6.0
	~dev-qt/qtcore-${PV}
	~dev-qt/qtdeclarative-${PV}
	~dev-qt/qtgui-${PV}[egl,libinput=]
	media-libs/mesa[egl]
	>=x11-libs/libxkbcommon-0.2.0
	xcomposite? (
		x11-libs/libX11
		x11-libs/libXcomposite
	)
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-fix-touch-ignored.patch" # QTBUG-79744
	"${FILESDIR}/${P}-fix-crash.patch" # QTBUG-79674
	# Pending upstream:
	"${FILESDIR}/${P}-fix-linuxdmabuf-build.patch" # bug 699190, QTBUG-79709
)

src_prepare() {
	qt_use_disable_config libinput xkbcommon-evdev \
		src/client/client.pro \
		src/compositor/wayland_wrapper/wayland_wrapper.pri \
		src/plugins/shellintegration/ivi-shell/ivi-shell.pro \
		src/plugins/shellintegration/wl-shell/wl-shell.pro \
		src/plugins/shellintegration/xdg-shell/xdg-shell.pro \
		src/plugins/shellintegration/xdg-shell-v5/xdg-shell-v5.pro \
		src/plugins/shellintegration/xdg-shell-v6/xdg-shell-v6.pro \
		tests/auto/compositor/compositor/compositor.pro

	use xcomposite || rm -r config.tests/xcomposite || die

	qt5-build_src_prepare
}
