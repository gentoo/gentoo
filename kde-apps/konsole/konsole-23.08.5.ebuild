# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="optional"
ECM_TEST="true"
KFMIN=5.106.0
QTMIN=5.15.9
inherit ecm gear.kde.org

DESCRIPTION="KDE's terminal emulator"
HOMEPAGE="https://apps.kde.org/konsole/ https://konsole.kde.org"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="amd64 arm64 ~loong ~ppc64 ~riscv x86"
IUSE=""

DEPEND="
	dev-libs/icu:=
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtmultimedia-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtprintsupport-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=kde-frameworks/kbookmarks-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/kglobalaccel-${KFMIN}:5
	>=kde-frameworks/kguiaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kjobwidgets-${KFMIN}:5
	>=kde-frameworks/knewstuff-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/knotifyconfig-${KFMIN}:5
	>=kde-frameworks/kparts-${KFMIN}:5
	>=kde-frameworks/kpty-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/ktextwidgets-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}-23.08.1-drop-unused-X11-dep.patch" ) # FIXME properly upstream

src_test() {
	# DBusTest: drkonqi process interferes. bug 702690
	# TerminalInterfaceTest: unbelievably flaky, bug 862594 and bug 662756
	local myctestargs=(
		-E "(DBusTest|TerminalInterfaceTest)"
	)

	ecm_src_test
}
