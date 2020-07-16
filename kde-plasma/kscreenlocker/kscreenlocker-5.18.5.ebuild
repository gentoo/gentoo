# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_TEST="forceoptional"
KFMIN=5.66.0
PVCUT=$(ver_cut 1-3)
QTMIN=5.12.3
VIRTUALX_REQUIRED="test"
inherit ecm kde.org pam

DESCRIPTION="Library and components for secure lock screen architecture"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="amd64 ~arm arm64 ~ppc64 x86"
IUSE="consolekit +pam seccomp"

REQUIRED_USE="seccomp? ( pam )"

RDEPEND="
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
	>=kde-frameworks/ktextwidgets-${KFMIN}:5
	>=kde-frameworks/kwayland-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-frameworks/solid-${KFMIN}:5
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5[widgets]
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtx11extras-${QTMIN}:5
	dev-libs/wayland
	x11-libs/libX11
	x11-libs/libXi
	x11-libs/libxcb
	x11-libs/xcb-util-keysyms
	consolekit? ( sys-auth/consolekit )
	pam? ( sys-libs/pam )
	seccomp? ( sys-libs/libseccomp )
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
"
PDEPEND="
	>=kde-plasma/kde-cli-tools-${PVCUT}:5
"

RESTRICT+=" test"

src_prepare() {
	ecm_src_prepare

	if ! use test; then
		sed -e "/add_subdirectory(autotests)/ s/^/#/" \
			-i greeter/CMakeLists.txt || die
	fi
}

src_test() {
	# requires running environment
	local myctestargs=(
		-E x11LockerTest
	)
	ecm_src_test
}

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package consolekit loginctl)
		-DPAM_REQUIRED=$(usex pam)
		$(cmake_use_find_package pam PAM)
		$(cmake_use_find_package seccomp Seccomp)
	)
	ecm_src_configure
}

src_install() {
	ecm_src_install

	use pam && newpamd "${FILESDIR}/kde.pam" kde
	use pam && newpamd "${FILESDIR}/kde-np.pam" kde-np

	if ! use pam; then
		chown root "${ED}"/usr/$(get_libdir)/libexec/kcheckpass || die
		chmod +s "${ED}"/usr/$(get_libdir)/libexec/kcheckpass || die
	fi
}
