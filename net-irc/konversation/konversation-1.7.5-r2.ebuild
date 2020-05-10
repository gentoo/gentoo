# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="forceoptional"
KFMIN=5.63.0
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="User friendly IRC Client"
HOMEPAGE="https://konversation.kde.org
https://kde.org/applications/internet/org.kde.konversation"
SRC_URI="mirror://kde/stable/${PN}/${PV/_/-}/src/${P/_/-}.tar.xz"

LICENSE="GPL-2"
SLOT="5"
KEYWORDS="amd64 ~arm64 ~ppc64 x86"
IUSE="+crypt"

BDEPEND="sys-devel/gettext"
DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=kde-frameworks/karchive-${KFMIN}:5
	>=kde-frameworks/kbookmarks-${KFMIN}:5=
	>=kde-frameworks/kcodecs-${KFMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/kglobalaccel-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kidletime-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kitemviews-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/knotifyconfig-${KFMIN}:5
	>=kde-frameworks/kparts-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/ktextwidgets-${KFMIN}:5
	>=kde-frameworks/kwallet-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	media-libs/phonon[qt5(+)]
	crypt? ( app-crypt/qca:2[qt5(+)] )
"
RDEPEND="${DEPEND}
	crypt? ( app-crypt/qca:2[ssl] )
"

PATCHES=(
	# 1.7 branch
	"${FILESDIR}"/${P}-fix-regex-for-cap-ack.patch
	"${FILESDIR}"/${P}-missing-header.patch
	"${FILESDIR}"/${P}-QElapsedTimer.patch
	"${FILESDIR}"/${P}-kf5windowsystem-5.63.patch
	# git master
	"${FILESDIR}"/${P}-kf5bookmarks-5.69.patch
	"${FILESDIR}"/${P}-unused-kemoticons.patch
	"${FILESDIR}"/${P}-qt-5.15.patch
)

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package crypt Qca-qt5)
	)

	ecm_src_configure
}

src_install() {
	ecm_src_install

	# Bug 616162
	insinto /etc/xdg
	doins "${FILESDIR}"/konversationrc
}
