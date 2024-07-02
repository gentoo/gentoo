# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
ECM_TEST="true"
KFMIN=6.3.0
PVCUT=$(ver_cut 1-3)
QTMIN=6.7.1
inherit ecm plasma.kde.org

DESCRIPTION="Tools based on KDE Frameworks 6 to better interact with the system"
HOMEPAGE="https://invent.kde.org/plasma/kde-cli-tools"

LICENSE="GPL-2" # TODO: CHECK
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~riscv"
IUSE="kdesu X"

REQUIRED_USE="kdesu? ( X )"
# requires running kde environment
RESTRICT="test"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,widgets]
	>=dev-qt/qtsvg-${QTMIN}:6
	>=kde-frameworks/kcmutils-${KFMIN}:6
	>=kde-frameworks/kcompletion-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kparts-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6[X?]
	kdesu? ( >=kde-frameworks/kdesu-${KFMIN}:6 )
	X? ( >=dev-qt/qtbase-${QTMIN}:6=[gui] )
"
RDEPEND="${DEPEND}
	kdesu? ( sys-apps/dbus[X] )
"
BDEPEND=">=kde-frameworks/kcmutils-${KFMIN}:6"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package kdesu KF6Su)
		-DWITH_X11=$(usex X)
	)

	ecm_src_configure
}

src_install() {
	ecm_src_install
	use kdesu && dosym ../libexec/kf6/kdesu /usr/bin/kdesu
}
