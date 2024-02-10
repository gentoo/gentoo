# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
KFMIN=5.82.0
QTMIN=5.15.2
inherit ecm kde.org

DESCRIPTION="Frontend to the subversion vcs"
HOMEPAGE="https://apps.kde.org/kdesvn/"

if [[ ${PV} != 9999* ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${PV}/${P}.tar.xz
		https://dev.gentoo.org/~asturm/distfiles/${P}-patchset-1.tar.xz"
	KEYWORDS="amd64 x86"
fi

LICENSE="GPL-2"
SLOT="5"
IUSE="+man"

DEPEND="
	dev-libs/apr:1
	dev-libs/apr-util:1
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtsql-${QTMIN}:5[sqlite]
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	dev-vcs/subversion
	>=kde-frameworks/kbookmarks-${KFMIN}:5
	>=kde-frameworks/kcodecs-${KFMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kitemviews-${KFMIN}:5
	>=kde-frameworks/kjobwidgets-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/kparts-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/ktextwidgets-${KFMIN}:5
	>=kde-frameworks/kwallet-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
"
RDEPEND="${DEPEND}"
BDEPEND="
	man? ( >=kde-frameworks/kdoctools-${KFMIN}:5 )
"

PATCHES=(
	"${WORKDIR}"/${P}-remove-help-button.patch # KDE-bug 410566
	"${WORKDIR}"/${P}-fix-openwith-context-menu.patch # KDE-bug 410585
	"${WORKDIR}"/${P}-fix-dupl-cli-options.patch
	"${WORKDIR}"/${P}-crashfix-w-o-local-checkout-path.patch # KDE-bug 419906
	"${WORKDIR}"/${P}-crashfix-closing-repo.patch # KDE-bug 437948
	"${WORKDIR}"/${P}-hidpi-{1,2}.patch
	"${WORKDIR}"/${P}-fix-deprecated.patch
)

src_prepare(){
	ecm_src_prepare

	if ! use man ; then
		sed -i -e "/kdoctools_create_manpage/ s/^/#/" doc/CMakeLists.txt || die
	fi
}
