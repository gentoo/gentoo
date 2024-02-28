# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="optional"
KFMIN=5.113.0
QTMIN=5.15.9
inherit ecm gear.kde.org

DESCRIPTION="Remote desktop connection (RDP and VNC) client"
HOMEPAGE="https://apps.kde.org/krdc/"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="activities +rdp +vnc"

#nx? ( >=net-misc/nxcl-0.9-r1 ) disabled upstream, last checked 2016-01-24
# TODO: in port to KF6: >=kde-frameworks/kstatusnotifieritem-${KFMIN}:6
DEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=kde-frameworks/kbookmarks-${KFMIN}:5
	>=kde-frameworks/kcmutils-${KFMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdnssd-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/knotifyconfig-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/kwallet-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	activities? ( >=kde-plasma/plasma-activities-${KFMIN}:5 )
	rdp? ( >=net-misc/freerdp-2.1.0:= <net-misc/freerdp-3 )
	vnc? (
		net-libs/libssh:=
		>=net-libs/libvncserver-0.9
	)
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		# TODO: in port to KF6: PlasmaActivities
		$(cmake_use_find_package activities KF5Activities)
		-DWITH_RDP=$(usex rdp)
		-DWITH_VNC=$(usex vnc)
	)

	ecm_src_configure
}
