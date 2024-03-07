# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
KFMIN=6.0
QTMIN=6.6.2
inherit ecm gear.kde.org

DESCRIPTION="User friendly IRC Client"
HOMEPAGE="https://konversation.kde.org https://apps.kde.org/konversation/"

LICENSE="GPL-2"
SLOT="6"
KEYWORDS="~amd64"
IUSE="+crypt"

DEPEND="
	>=dev-qt/qt5compat-${QTMIN}:6
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,network,widgets,xml]
	>=dev-qt/qtmultimedia-${QTMIN}:6
	>=dev-qt/qttools-${QTMIN}:6[qdbus]
	>=kde-frameworks/karchive-${KFMIN}:6
	>=kde-frameworks/kbookmarks-${KFMIN}:6
	>=kde-frameworks/kcodecs-${KFMIN}:6
	>=kde-frameworks/kcolorscheme-${KFMIN}:6
	>=kde-frameworks/kcompletion-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/kglobalaccel-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kidletime-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kitemviews-${KFMIN}:6
	>=kde-frameworks/knewstuff-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/knotifyconfig-${KFMIN}:6
	>=kde-frameworks/kparts-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
	>=kde-frameworks/kstatusnotifieritem-${KFMIN}:6
	>=kde-frameworks/ktextwidgets-${KFMIN}:6
	>=kde-frameworks/kwallet-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6[X]
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	crypt? ( >=app-crypt/qca-2.3.7:2[qt6] )
"
RDEPEND="${DEPEND}
	>=dev-qt/qtsvg-${QTMIN}:6
	crypt? ( >=app-crypt/qca-2.3.7:2[qt6,ssl] )
"
BDEPEND="sys-devel/gettext"

PATCHES=( "${FILESDIR}/${P}-delay-tray-setup.patch" )

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package crypt Qca-qt6)
	)

	ecm_src_configure
}

src_install() {
	ecm_src_install

	# Bug 616162
	insinto /etc/xdg
	doins "${FILESDIR}"/konversationrc
}
