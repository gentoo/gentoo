# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="optional"
ECM_TEST="true"
KDE_ORG_NAME="${PN}-kde"
KDE_RELEASE_SERVICE="true"
KDE_SELINUX_MODULE="${PN}"
KFMIN=5.70.0
QTMIN=5.14.2
inherit ecm kde.org

DESCRIPTION="Adds communication between KDE Plasma and your smartphone"
HOMEPAGE="https://kdeconnect.kde.org/
https://apps.kde.org/en/kdeconnect.kcm"

LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="amd64 arm64 x86"
IUSE="bluetooth pulseaudio wayland X"

DEPEND="
	>=app-crypt/qca-2.3.0:2[ssl]
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtmultimedia-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kcmutils-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kirigami-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/kpeople-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/plasma-${KFMIN}:5
	bluetooth? ( >=dev-qt/qtbluetooth-${QTMIN}:5 )
	X? (
		>=dev-qt/qtx11extras-${QTMIN}:5
		x11-libs/libfakekey
		x11-libs/libX11
		x11-libs/libXtst
	)
	pulseaudio? ( media-libs/pulseaudio-qt )
	wayland? ( >=kde-frameworks/kwayland-${KFMIN}:5 )
"
RDEPEND="${DEPEND}
	dev-libs/kpeoplevcard
	>=dev-qt/qtgraphicaleffects-${QTMIN}:5
	>=dev-qt/qtquickcontrols2-${QTMIN}:5
	>=kde-frameworks/kdeclarative-${KFMIN}:5
	net-fs/sshfs
"

RESTRICT+=" test"

PATCHES=(
	# CVE-2020-26164, bug 746401
	"${FILESDIR}"/${P}-01-Do-not-ignore-SSL-errors-except-for-self-signed-cert.patch
	"${FILESDIR}"/${P}-02-Do-not-leak-the-local-user-in-the-device-name.patch
	"${FILESDIR}"/${P}-03-Fix-use-after-free-in-LanLinkProvider-connectError.patch
	"${FILESDIR}"/${P}-04-Limit-identity-packets-to-8KiB.patch
	"${FILESDIR}"/${P}-05-Do-not-let-lanlink-connections-stay-open-for-long-wi.patch
	"${FILESDIR}"/${P}-06-Don-t-brute-force-reading-the-socket.patch
	"${FILESDIR}"/${P}-07-Limit-number-of-connected-sockets-from-unpaired-devi.patch
	"${FILESDIR}"/${P}-08-Do-not-remember-more-than-a-few-identity-packets-at-.patch
	"${FILESDIR}"/${P}-09-Limit-the-ports-we-try-to-connect-to-to-the-port-ran.patch
	"${FILESDIR}"/${P}-10-Do-not-replace-connections-for-a-given-deviceId-if-t.patch
)

src_configure() {
	local mycmakeargs=(
		-DBLUETOOTH_ENABLED=$(usex bluetooth)
		$(cmake_use_find_package pulseaudio KF5PulseAudioQt)
		$(cmake_use_find_package wayland KF5Wayland)
		$(cmake_use_find_package X LibFakeKey)
	)

	ecm_src_configure
}

pkg_postinst(){
	ecm_pkg_postinst

	elog "The Android .apk file is available via"
	elog "https://play.google.com/store/apps/details?id=org.kde.kdeconnect_tp"
	elog "or via"
	elog "https://f-droid.org/packages/org.kde.kdeconnect_tp/"
}
