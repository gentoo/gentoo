# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="optional"
ECM_TEST="true"
KFMIN=6.10.0
QTMIN=6.8.1
inherit ecm fcaps plasma.kde.org xdg

DESCRIPTION="Flexible, composited Window Manager for windowing systems on Linux"

LICENSE="GPL-2+"
SLOT="6"
KEYWORDS="amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="accessibility gles2-only lock screencast +shortcuts systemd"

RESTRICT="test"

# qtbase slot op: GuiPrivate use in tabbox
# qtbase[X]: private/qtx11extras_p.h in src/helpers/killer
COMMON_DEPEND="
	dev-libs/libei
	>=dev-libs/libinput-1.27:=
	>=dev-libs/wayland-1.23.0
	>=dev-qt/qt5compat-${QTMIN}:6[qml]
	>=dev-qt/qtbase-${QTMIN}:6=[accessibility=,gles2-only=,gui,libinput,opengl,wayland,widgets,X]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=dev-qt/qtsensors-${QTMIN}:6
	>=dev-qt/qtshadertools-${QTMIN}:6
	>=dev-qt/qtsvg-${QTMIN}:6
	>=kde-frameworks/kauth-${KFMIN}:6
	>=kde-frameworks/kcmutils-${KFMIN}:6
	>=kde-frameworks/kcolorscheme-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6[qml]
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/kdeclarative-${KFMIN}:6
	>=kde-frameworks/kglobalaccel-${KFMIN}:6=[X(+)]
	>=kde-frameworks/kguiaddons-${KFMIN}:6[wayland]
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kidletime-${KFMIN}:6=[wayland]
	>=kde-frameworks/knewstuff-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/kpackage-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
	>=kde-frameworks/ksvg-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6=[wayland,X]
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	>=kde-plasma/breeze-${KDE_CATV}:6
	>=kde-plasma/kdecoration-${KDE_CATV}:6
	>=kde-plasma/kwayland-${KDE_CATV}:6
	>=kde-plasma/plasma-activities-${KDE_CATV}:6
	media-libs/fontconfig
	media-libs/freetype
	media-libs/lcms:2
	media-libs/libcanberra
	>=media-libs/libdisplay-info-0.2.0:=
	media-libs/libepoxy
	media-libs/libglvnd
	>=media-libs/mesa-24.1.0_rc1[opengl,wayland,X]
	virtual/libudev:=
	x11-libs/libX11
	x11-libs/libXi
	>=x11-libs/libdrm-2.4.116
	>=x11-libs/libxcb-1.10:=
	>=x11-libs/libxcvt-0.1.1
	>=x11-libs/libxkbcommon-1.5.0
	x11-libs/xcb-util-cursor
	x11-libs/xcb-util-keysyms
	x11-libs/xcb-util-wm
	accessibility? ( media-libs/libqaccessibilityclient:6 )
	lock? ( >=kde-plasma/kscreenlocker-${KDE_CATV}:6 )
	screencast? ( >=media-video/pipewire-1.2.0:= )
	shortcuts? ( >=kde-plasma/kglobalacceld-${KDE_CATV}:6 )
"
RDEPEND="${COMMON_DEPEND}
	!kde-plasma/kdeplasma-addons:5
	>=dev-qt/qtmultimedia-${QTMIN}:6[qml]
	|| (
		dev-qt/qtmultimedia:6[ffmpeg]
		(
			dev-qt/qtmultimedia:6[gstreamer]
			media-plugins/gst-plugins-soup:1.0
		)
	)
	>=kde-frameworks/kirigami-${KFMIN}:6
	>=kde-frameworks/kitemmodels-${KFMIN}:6
	>=kde-plasma/aurorae-${KDE_CATV}:6
	>=kde-plasma/libplasma-${KDE_CATV}:6[wayland(+)]
	sys-apps/hwdata
	>=x11-base/xwayland-23.1.0[libei]
"
RDEPEND+=" || ( >=dev-qt/qtbase-6.10:6[wayland] <dev-qt/qtwayland-6.10:6 )"
DEPEND="${COMMON_DEPEND}
	>=dev-libs/plasma-wayland-protocols-1.16.0
	>=dev-libs/wayland-protocols-1.38
	>=dev-qt/qttools-${QTMIN}:6[widgets]
	>=dev-qt/qtbase-${QTMIN}:6[concurrent]
	x11-base/xorg-proto
	x11-libs/xcb-util-image
	test? ( screencast? ( >=kde-plasma/kpipewire-${KDE_CATV}:6 ) )
"
BDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[wayland]
	dev-util/wayland-scanner
	>=kde-frameworks/kcmutils-${KFMIN}:6
"
BDEPEND+=" || ( >=dev-qt/qtbase-6.10:6[wayland] <dev-qt/qtwayland-6.10:6 )"

# https://bugs.gentoo.org/941628
# -m 0755 to avoid suid with USE="-filecaps"
FILECAPS=( -m 0755 cap_sys_nice=ep usr/bin/kwin_wayland )

src_prepare() {
	ecm_src_prepare

	# TODO: try to get a build switch upstreamed
	if ! use screencast; then
		sed -e "s/^pkg_check_modules.*PipeWire/#&/" -i CMakeLists.txt || die
	fi

	# TODO: try to get a build switch upstreamed
	if ! use systemd; then
		sed -e "s/^pkg_check_modules.*libsystemd/#&/" -i CMakeLists.txt || die
	fi

	cmake_run_in src/plugins cmake_comment_add_subdirectory kdecorations
}

src_configure() {
	local mycmakeargs=(
		# TODO: KWIN_BUILD_X11=$(usex xwayland) KWIN_BUILD_X11_BACKEND=$(usex X)
		# KWIN_BUILD_NOTIFICATIONS exists, but kdeclarative still hard-depends on it
		$(cmake_use_find_package accessibility QAccessibilityClient6)
		-DCMAKE_DISABLE_FIND_PACKAGE_Libcap=ON
		-DKWIN_BUILD_SCREENLOCKER=$(usex lock)
		-DKWIN_BUILD_GLOBALSHORTCUTS=$(usex shortcuts)
	)

	ecm_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	fcaps_pkg_postinst
}
