# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="true"
KDE_ORG_NAME="${PN}-kde"
KDE_SELINUX_MODULE="${PN}"
KFMIN=6.22.0
QTMIN=6.10.1
inherit ecm flag-o-matic gear.kde.org xdg

DESCRIPTION="Adds communication between KDE Plasma and your smartphone"
HOMEPAGE="https://kdeconnect.kde.org/ https://apps.kde.org/kdeconnect/"

LICENSE="GPL-2+"
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE="bluetooth pulseaudio telephony X"

RESTRICT="test"

# slot op: Uses Qt6::GuiPrivate for qpa/qplatformnativeinterface.h, qtx11extras_p.h
COMMON_DEPEND="
	dev-libs/libei
	dev-libs/openssl:=
	>=dev-libs/wayland-1.15.0
	>=dev-qt/qtbase-${QTMIN}:6=[dbus,gui,network,wayland,widgets,X?]
	>=dev-qt/qtdeclarative-${QTMIN}:6[widgets]
	>=dev-qt/qtmultimedia-${QTMIN}:6
	>=kde-frameworks/kcolorscheme-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6[qml]
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/kguiaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kirigami-${KFMIN}:6
	>=kde-frameworks/kitemmodels-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/kpeople-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
	>=kde-frameworks/kstatusnotifieritem-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6
	>=kde-frameworks/qqc2-desktop-style-${KFMIN}:6
	>=kde-frameworks/solid-${KFMIN}:6
	sys-apps/dbus
	bluetooth? ( >=dev-qt/qtconnectivity-${QTMIN}:6[bluetooth] )
	pulseaudio? ( >=media-libs/pulseaudio-qt-1.4:= )
	telephony? ( >=kde-frameworks/modemmanager-qt-${KFMIN}:6 )
	X? (
		x11-libs/libfakekey
		x11-libs/libX11
		x11-libs/libXtst
		x11-libs/libxkbcommon
	)
"
DEPEND="${COMMON_DEPEND}
	dev-libs/wayland-protocols
"
RDEPEND="${COMMON_DEPEND}
	dev-libs/kirigami-addons:6
	>=dev-qt/qt5compat-${QTMIN}:6[qml]
	>=dev-qt/qtmultimedia-${QTMIN}:6[qml]
	>=dev-qt/qttools-${QTMIN}:6[qdbus]
	>=kde-frameworks/kdeclarative-${KFMIN}:6
	>=kde-frameworks/kdnssd-${KFMIN}:6
	kde-plasma/libplasma:6
	net-fs/sshfs
"
BDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[wayland]
	dev-util/wayland-scanner
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/${P}-openssl4.patch" # in 26.08
	# Pending: https://invent.kde.org/network/kdeconnect-kde/-/merge_requests/997
	"${FILESDIR}/${P}-with_x11.patch"
)

src_prepare() {
	ecm_src_prepare

	if ! use X; then
		# TODO: make conditional on X upstream
		# uses private/qxkbcommon_p.h:
		cmake_comment_add_subdirectory -f plugins shareinputdevices
	fi
}

src_configure() {
	# -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/921648
	# https://bugs.kde.org/show_bug.cgi?id=480522
	filter-lto

	local mycmakeargs=(
		-DBLUETOOTH_ENABLED=$(usex bluetooth)
		-DWITH_PULSEAUDIO=$(usex pulseaudio)
		$(cmake_use_find_package telephony KF6ModemManagerQt)
		-DWITH_X11=$(usex X)
	)
	ecm_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst

	elog "The Android .apk file is available via"
	elog "https://play.google.com/store/apps/details?id=org.kde.kdeconnect_tp"
	elog "or via"
	elog "https://f-droid.org/packages/org.kde.kdeconnect_tp/"
}
