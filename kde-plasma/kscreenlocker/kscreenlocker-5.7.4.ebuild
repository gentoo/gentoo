# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_TEST="forceoptional"
VIRTUALX_REQUIRED="test"
inherit kde5 pam

DESCRIPTION="Library and components for secure lock screen architecture"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="pam"

COMMON_DEPEND="
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
	pam? ( virtual/pam )
"
DEPEND="${COMMON_DEPEND}
	x11-proto/xproto
"
RDEPEND="${COMMON_DEPEND}
	$(add_plasma_dep kde-cli-tools)
	!<kde-base/kcheckpass-4.11.22-r1:4
	!kde-base/kdebase-pam:0
	!<kde-plasma/plasma-workspace-5.4.50
"

RESTRICT="test"

src_prepare() {
	kde5_src_prepare

	use test || sed -i \
		-e "/add_subdirectory(autotests)/ s/^/#/" greeter/CMakeLists.txt || die
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
		$(cmake-utils_use_find_package pam PAM)
	)
	kde5_src_configure
}

src_install() {
	kde5_src_install

	newpamd "${FILESDIR}/kde.pam" kde
	newpamd "${FILESDIR}/kde-np.pam" kde-np

	if ! use pam; then
		chown root "${ED}"usr/$(get_libdir)/libexec/kcheckpass || die
		chmod +s "${ED}"usr/$(get_libdir)/libexec/kcheckpass || die
	fi
}
