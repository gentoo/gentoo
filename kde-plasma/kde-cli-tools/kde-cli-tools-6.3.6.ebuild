# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoff"
ECM_TEST="false"
KFMIN=6.10.0
QTMIN=6.8.1
inherit ecm plasma.kde.org xdg

DESCRIPTION="Tools based on KDE Frameworks 6 to better interact with the system"
HOMEPAGE="https://invent.kde.org/plasma/kde-cli-tools"

LICENSE="GPL-2" # TODO: CHECK
SLOT="6"
KEYWORDS="amd64 arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="kdesu X"

# slot op: kstart Uses Qt6::GuiPrivate for qtx11extras_p.h
DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,widgets]
	>=dev-qt/qtsvg-${QTMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
	X? ( >=dev-qt/qtbase-${QTMIN}:6=[gui,X] )
"
RDEPEND="${DEPEND}
	>=${CATEGORY}/${PN}-common-${PV}
	kdesu? ( >=${CATEGORY}/kdesu-gui-${PV} )
"
BDEPEND=">=kde-frameworks/kcmutils-${KFMIN}:6"

# downstream split
PATCHES=( "${FILESDIR}/${PN}-6.2.4-unrequire-kf-qt-modules.patch" )

src_prepare() {
	ecm_src_prepare
	ecm_punt_po_install
	cmake_comment_add_subdirectory keditfiletype # split package
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_KF6Su=ON
		-DWITH_X11=$(usex X)
	)

	ecm_src_configure
}
