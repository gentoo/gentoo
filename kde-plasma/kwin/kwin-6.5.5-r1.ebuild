# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="optional"
# TODO: ECMGenerateQDoc
ECM_TEST="true"
KFMIN=6.22.0
QTMIN=6.10.1
inherit ecm fcaps plasma.kde.org toolchain-funcs xdg

DESCRIPTION="Flexible, composited Window Manager for windowing systems on Linux"
SRC_URI+=" https://dev.gentoo.org/~asturm/distfiles/kde/${P}-patchset.tar.xz"

LICENSE="GPL-2+"
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="accessibility gles2-only lock screencast +shortcuts systemd X"

RESTRICT="test"

# qtbase slot op: GuiPrivate use in tabbox, Qt6WaylandClientPrivate for xx-pip-v1
# qtbase[X]: private/qtx11extras_p.h in src/helpers/killer
COMMON_DEPEND="
	dev-libs/libei
	>=dev-libs/libinput-1.27:=
	>=dev-libs/wayland-1.24.0
	>=dev-qt/qt5compat-${QTMIN}:6[qml]
	>=dev-qt/qtbase-${QTMIN}:6=[accessibility=,gles2-only=,gui,libinput,opengl,wayland,widgets,X]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=dev-qt/qtsensors-${QTMIN}:6
	>=dev-qt/qtsvg-${QTMIN}:6
	>=dev-qt/qttools-${QTMIN}:6[widgets]
	>=kde-frameworks/kauth-${KFMIN}:6
	>=kde-frameworks/kcmutils-${KFMIN}:6
	>=kde-frameworks/kcolorscheme-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6[qml]
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/kdeclarative-${KFMIN}:6
	>=kde-frameworks/kglobalaccel-${KFMIN}:6
	>=kde-frameworks/kguiaddons-${KFMIN}:6[wayland]
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kidletime-${KFMIN}:6=[wayland]
	>=kde-frameworks/knewstuff-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/kpackage-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
	>=kde-frameworks/ksvg-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6=[wayland]
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	>=kde-plasma/kdecoration-${KDE_CATV}:6
	>=kde-plasma/knighttime-${KDE_CATV}:6
	>=kde-plasma/kwayland-${KDE_CATV}:6
	>=kde-plasma/plasma-activities-${KDE_CATV}:6=
	media-libs/lcms:2
	media-libs/libcanberra
	>=media-libs/libdisplay-info-0.2.0:=
	media-libs/libepoxy
	media-libs/libglvnd
	>=media-libs/mesa-24.1.0_rc1[opengl,wayland]
	virtual/libudev:=
	>=x11-libs/libdrm-2.4.118
	>=x11-libs/libxcvt-0.1.1
	>=x11-libs/libxkbcommon-1.5.0
	accessibility? ( media-libs/libqaccessibilityclient:6 )
	lock? ( >=kde-plasma/kscreenlocker-${KDE_CATV}:6 )
	screencast? ( >=media-video/pipewire-1.2.0:= )
	shortcuts? ( >=kde-plasma/kglobalacceld-${KDE_CATV}:6 )
	systemd? ( sys-apps/systemd:= )
	X? (
		x11-libs/libX11
		>=x11-libs/libxcb-1.10:=
		x11-libs/libXi
		x11-libs/libXres
		x11-libs/xcb-util-cursor
		x11-libs/xcb-util-keysyms
		x11-libs/xcb-util-wm
	)
"
RDEPEND="${COMMON_DEPEND}
	!kde-plasma/kdeplasma-addons:5
	>=kde-frameworks/kirigami-${KFMIN}:6
	>=kde-frameworks/kitemmodels-${KFMIN}:6
	>=kde-plasma/aurorae-${KDE_CATV}:6
	>=kde-plasma/breeze-${KDE_CATV}:6
	>=kde-plasma/libplasma-${KDE_CATV}:6
	sys-apps/hwdata
	X? ( >=x11-base/xwayland-23.1.0[libei] )
"
DEPEND="${COMMON_DEPEND}
	>=dev-libs/plasma-wayland-protocols-1.19.0
	>=dev-libs/wayland-protocols-1.45
	>=dev-qt/qtbase-${QTMIN}:6[concurrent]
	test? ( screencast? ( >=kde-plasma/kpipewire-${KDE_CATV}:6 ) )
	X? ( x11-base/xorg-proto )
"
BDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[wayland]
	dev-util/wayland-scanner
	>=kde-frameworks/kcmutils-${KFMIN}:6
"

# https://bugs.gentoo.org/941628
# -m 0755 to avoid suid with USE="-filecaps"
FILECAPS=( -m 0755 cap_sys_nice=ep usr/bin/kwin_wayland )

PATCHES=(
	"${WORKDIR}/${P}-patchset"
	"${FILESDIR}/${P}-unused-deps.patch" # bug #965053
)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && tc-check-min_ver gcc 14
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && tc-check-min_ver gcc 14
}

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
}

src_configure() {
	local mycmakeargs=(
		# KWIN_BUILD_DECORATIONS exists, drops aurorae, breeze
		# KWIN_BUILD_NOTIFICATIONS exists, but kdeclarative still hard-depends on it
		$(cmake_use_find_package accessibility QAccessibilityClient6)
		-DKWIN_BUILD_SCREENLOCKER=$(usex lock)
		-DKWIN_BUILD_GLOBALSHORTCUTS=$(usex shortcuts)
		-DKWIN_BUILD_X11=$(usex X)
	)

	ecm_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	fcaps_pkg_postinst
}
