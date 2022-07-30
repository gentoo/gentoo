# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="forceoptional"
KFMIN=5.92.0
PVCUT=$(ver_cut 1-3)
QTMIN=5.15.4
VIRTUALX_REQUIRED="test"
inherit ecm plasma.kde.org pam

DESCRIPTION="Library and components for secure lock screen architecture"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv x86"
IUSE="+pam"

RESTRICT="test"

COMMON_DEPEND="
	dev-libs/wayland
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtx11extras-${QTMIN}:5
	>=kde-frameworks/kcmutils-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/kdeclarative-${KFMIN}:5
	>=kde-frameworks/kglobalaccel-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kidletime-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/kpackage-${KFMIN}:5
	>=kde-frameworks/kwayland-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-frameworks/solid-${KFMIN}:5
	>=kde-plasma/layer-shell-qt-${PVCUT}:5
	x11-libs/libX11
	x11-libs/libXi
	x11-libs/libxcb
	x11-libs/xcb-util-keysyms
	pam? ( sys-libs/pam )
"
DEPEND="${COMMON_DEPEND}
	x11-base/xorg-proto
"
RDEPEND="${COMMON_DEPEND}
	>=dev-qt/qtquickcontrols2-${QTMIN}:5
	>=kde-frameworks/kirigami-${KFMIN}:5
	>=kde-frameworks/plasma-${KFMIN}:5
"
PDEPEND=">=kde-plasma/kde-cli-tools-${PVCUT}:5"
BDEPEND="dev-util/wayland-scanner"

src_prepare() {
	ecm_src_prepare
	use test || cmake_run_in greeter cmake_comment_add_subdirectory autotests
}

src_configure() {
	local mycmakeargs=(
		-DPAM_REQUIRED=$(usex pam)
		$(cmake_use_find_package pam PAM)
	)
	ecm_src_configure
}

src_test() {
	# requires running environment
	local myctestargs=(
		-E x11LockerTest
	)
	ecm_src_test
}

src_install() {
	ecm_src_install

	if use pam; then
		newpamd "${FILESDIR}/kde.pam" kde
		newpamd "${FILESDIR}/kde-np.pam" kde-np
	else
		chown root "${ED}"/usr/$(get_libdir)/libexec/kcheckpass || die
		chmod +s "${ED}"/usr/$(get_libdir)/libexec/kcheckpass || die
	fi
}
