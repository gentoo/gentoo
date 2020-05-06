# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="forceoptional"
ECM_TEST="true"
KFMIN=5.66.0
PVCUT=$(ver_cut 1-3)
QTMIN=5.12.3
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="KDE Plasma desktop"

# Avoid pulling in xf86-input-{evdev,libinput,synaptics} DEPENDs
# just for 1 header each. touchpad also uses a header from xorg-server.
SHA_EVDEV="425ed601"
SHA_LIBINPUT="e52daf20"
SHA_SYNAPTICS="383355fa"
SHA_XSERVER="d511a301"
XORG_URI="https://gitlab.freedesktop.org/xorg/driver/PKG/-/raw"
SRC_URI+="
	${XORG_URI/PKG/xf86-input-evdev}/${SHA_EVDEV}/include/evdev-properties.h -> evdev-properties.h-${SHA_EVDEV}
	${XORG_URI/PKG/xf86-input-libinput}/${SHA_LIBINPUT}/include/libinput-properties.h -> libinput-properties.h-${SHA_LIBINPUT}
	${XORG_URI/PKG/xf86-input-synaptics}/${SHA_SYNAPTICS}/include/synaptics-properties.h -> synaptics-properties.h-${SHA_SYNAPTICS}
	${XORG_URI/driver\/PKG/xserver}/${SHA_XSERVER}/include/xserver-properties.h -> xserver-properties.h-${SHA_XSERVER}
"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="+fontconfig ibus scim +semantic-desktop"

COMMON_DEPEND="
	>=dev-qt/qtconcurrent-${QTMIN}:5
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtprintsupport-${QTMIN}:5
	>=dev-qt/qtsql-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtx11extras-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=kde-frameworks/attica-${KFMIN}:5
	>=kde-frameworks/kactivities-${KFMIN}:5
	>=kde-frameworks/kactivities-stats-${KFMIN}:5
	>=kde-frameworks/karchive-${KFMIN}:5
	>=kde-frameworks/kauth-${KFMIN}:5
	>=kde-frameworks/kbookmarks-${KFMIN}:5
	>=kde-frameworks/kcmutils-${KFMIN}:5
	>=kde-frameworks/kcodecs-${KFMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/kdeclarative-${KFMIN}:5
	>=kde-frameworks/kded-${KFMIN}:5
	>=kde-frameworks/kdelibs4support-${KFMIN}:5
	>=kde-frameworks/kemoticons-${KFMIN}:5
	>=kde-frameworks/kglobalaccel-${KFMIN}:5
	>=kde-frameworks/kguiaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kitemmodels-${KFMIN}:5
	>=kde-frameworks/kitemviews-${KFMIN}:5
	>=kde-frameworks/kjobwidgets-${KFMIN}:5
	>=kde-frameworks/knewstuff-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/knotifyconfig-${KFMIN}:5
	>=kde-frameworks/kparts-${KFMIN}:5
	>=kde-frameworks/krunner-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/kwallet-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-frameworks/plasma-${KFMIN}:5
	>=kde-frameworks/solid-${KFMIN}:5
	>=kde-frameworks/sonnet-${KFMIN}:5
	>=kde-plasma/kwin-${PVCUT}:5
	>=kde-plasma/libksysguard-${PVCUT}:5
	>=kde-plasma/plasma-workspace-${PVCUT}:5
	media-libs/phonon[qt5(+)]
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libxcb[xkb]
	x11-libs/libxkbfile
	fontconfig? (
		media-libs/fontconfig
		media-libs/freetype
		x11-libs/libXft
		x11-libs/xcb-util-image
	)
	ibus? (
		app-i18n/ibus
		dev-libs/glib:2
		>=dev-qt/qtx11extras-${QTMIN}:5
		x11-libs/libxcb
		x11-libs/xcb-util-keysyms
	)
	scim? ( app-i18n/scim )
	semantic-desktop? ( >=kde-frameworks/baloo-${KFMIN}:5 )
"
DEPEND="${COMMON_DEPEND}
	dev-libs/boost
	x11-base/xorg-proto
	fontconfig? ( x11-libs/libXrender )
"
RDEPEND="${COMMON_DEPEND}
	>=dev-qt/qtgraphicaleffects-${QTMIN}:5
	>=dev-qt/qtquickcontrols2-${QTMIN}:5
	>=kde-frameworks/kirigami-${KFMIN}:5
	>=kde-frameworks/qqc2-desktop-style-${KFMIN}:5
	>=kde-plasma/breeze-${PVCUT}:5
	>=kde-plasma/kde-cli-tools-${PVCUT}:5
	>=kde-plasma/oxygen-${PVCUT}:5
	sys-apps/util-linux
	x11-apps/setxkbmap
	!<kde-plasma/kdeplasma-addons-5.15.80
"

PATCHES=(
	"${FILESDIR}/${PN}-5.18.4.1-override-include-dirs.patch" # downstream patch
	"${FILESDIR}/${PN}-5.18.4.1-synaptics-header.patch" # in Plasma/5.19
)

src_unpack() {
	kde.org_src_unpack
	mkdir "${WORKDIR}/include" || die "Failed to prepare evdev/libinput dir"
	cp "${DISTDIR}"/evdev-properties.h-${SHA_EVDEV} \
		"${WORKDIR}"/include/evdev-properties.h || die "Failed to copy evdev"
	cp "${DISTDIR}"/libinput-properties.h-${SHA_LIBINPUT} \
		"${WORKDIR}"/include/libinput-properties.h || die "Failed to copy libinput"
	cp "${DISTDIR}"/synaptics-properties.h-${SHA_SYNAPTICS} \
		"${WORKDIR}"/include/synaptics-properties.h || die "Failed to copy synaptics"
	cp "${DISTDIR}"/xserver-properties.h-${SHA_XSERVER} \
		"${WORKDIR}"/include/xserver-properties.h || die "Failed to copy xserver"
}

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package fontconfig Fontconfig)
		-DEvdev_INCLUDE_DIRS="${WORKDIR}"/include
		-DXORGLIBINPUT_INCLUDE_DIRS="${WORKDIR}"/include
		-DSynaptics_INCLUDE_DIRS="${WORKDIR}"/include
		$(cmake_use_find_package ibus IBus)
		$(cmake_use_find_package scim SCIM)
		$(cmake_use_find_package semantic-desktop KF5Baloo)
	)

	ecm_src_configure
}

src_test() {
	# parallel tests fail, foldermodeltest,positionertest hang, bug #646890
	# needs D-Bus, bug #634166
	local myctestargs=(
		-j1
		-E "(foldermodeltest|positionertest|test_kio_fonts)"
	)

	ecm_src_test
}
