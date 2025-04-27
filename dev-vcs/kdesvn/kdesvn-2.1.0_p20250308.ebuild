# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
KDE_ORG_COMMIT="5d98288de13b7fa2a31a5d2bf42a28867de65b5f"
KFMIN=6.9.0
QTMIN=6.7.2
inherit ecm kde.org xdg

DESCRIPTION="Frontend to the subversion vcs"
HOMEPAGE="https://apps.kde.org/kdesvn/"
SRC_URI+=" https://dev.gentoo.org/~asturm/distfiles/${P}-kf6.patch.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+man"

DEPEND="
	dev-libs/apr:1
	dev-libs/apr-util:1
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,sql,sqlite,widgets,xml]
	dev-vcs/subversion
	>=kde-frameworks/kbookmarks-${KFMIN}:6
	>=kde-frameworks/kcodecs-${KFMIN}:6
	>=kde-frameworks/kcompletion-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kitemviews-${KFMIN}:6
	>=kde-frameworks/kjobwidgets-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/kparts-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
	>=kde-frameworks/ktextwidgets-${KFMIN}:6
	>=kde-frameworks/kwallet-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
"
RDEPEND="${DEPEND}"
BDEPEND="
	man? ( >=kde-frameworks/kdoctools-${KFMIN}:6 )
"

# MR pending: https://invent.kde.org/sdk/kdesvn/-/merge_requests/17
PATCHES=( "${WORKDIR}/${P}-kf6.patch" )

src_prepare(){
	ecm_src_prepare

	if ! use man ; then
		sed -i -e "/kdoctools_create_manpage/ s/^/#/" doc/CMakeLists.txt || die
	fi
}
