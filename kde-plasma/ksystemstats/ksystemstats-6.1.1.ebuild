# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
ECM_TEST="forceoptional"
KFMIN=6.3.0
PVCUT=$(ver_cut 1-3)
QTMIN=6.7.1
VIRTUALX_REQUIRED="test" # bug 909312 (test fails)
inherit ecm plasma.kde.org virtualx

DESCRIPTION="Plugin-based system monitoring daemon"

LICENSE="GPL-2+"
SLOT="6"
KEYWORDS="~amd64 ~arm64"
IUSE="networkmanager"

DEPEND="
	dev-libs/libnl:3
	>=dev-qt/qtbase-${QTMIN}:6[dbus,network]
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/solid-${KFMIN}:6
	>=kde-plasma/libksysguard-${PVCUT}:6
	net-libs/libpcap
	sys-apps/lm-sensors:=
	sys-libs/libcap
	virtual/libudev:=
	networkmanager? ( >=kde-frameworks/networkmanager-qt-${KFMIN}:6 )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package networkmanager KF6NetworkManagerQt)
	)
	ecm_src_configure
}
