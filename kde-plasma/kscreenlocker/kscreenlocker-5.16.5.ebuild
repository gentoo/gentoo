# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_TEST="forceoptional"
VIRTUALX_REQUIRED="test"
inherit kde5 pam

DESCRIPTION="Library and components for secure lock screen architecture"
KEYWORDS="amd64 ~arm arm64 x86"
IUSE="consolekit +pam seccomp"

REQUIRED_USE="seccomp? ( pam )"

RDEPEND="
	$(add_frameworks_dep kcmutils)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep kdeclarative)
	$(add_frameworks_dep kglobalaccel)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kidletime)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep kpackage)
	$(add_frameworks_dep ktextwidgets)
	$(add_frameworks_dep kwayland)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep solid)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtdeclarative 'widgets')
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtx11extras)
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
	$(add_plasma_dep kde-cli-tools)
"

RESTRICT+=" test"

src_prepare() {
	kde5_src_prepare

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
	kde5_src_test
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package consolekit loginctl)
		-DPAM_REQUIRED=$(usex pam)
		$(cmake-utils_use_find_package pam PAM)
		$(cmake-utils_use_find_package seccomp Seccomp)
	)
	kde5_src_configure
}

src_install() {
	kde5_src_install

	use pam && newpamd "${FILESDIR}/kde.pam" kde
	use pam && newpamd "${FILESDIR}/kde-np.pam" kde-np

	if ! use pam; then
		chown root "${ED}"/usr/$(get_libdir)/libexec/kcheckpass || die
		chmod +s "${ED}"/usr/$(get_libdir)/libexec/kcheckpass || die
	fi
}
