# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
KFMIN=5.82.0
QTMIN=5.15.2
inherit ecm kde.org

DESCRIPTION="Free/Open Source micro-blogging client by KDE"
HOMEPAGE="https://choqok.kde.org/ https://apps.kde.org/choqok/"

if [[ ${KDE_BUILD_TYPE} != live ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${PV%.0}/src/${P}.tar.xz
	https://dev.gentoo.org/~asturm/distfiles/${P}-patchset-1.tar.xz"
	KEYWORDS="amd64 x86"
fi

LICENSE="GPL-2+"
SLOT="5"
IUSE="attica share telepathy"

DEPEND="
	>=app-crypt/qca-2.3.0:2
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetworkauth-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=kde-frameworks/kcmutils-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kemoticons-${KFMIN}:5
	>=kde-frameworks/kglobalaccel-${KFMIN}:5
	>=kde-frameworks/kguiaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kjobwidgets-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/knotifyconfig-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/ktextwidgets-${KFMIN}:5
	>=kde-frameworks/kwallet-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-frameworks/sonnet-${KFMIN}:5
	attica? ( >=kde-frameworks/attica-${KFMIN}:5 )
	share? ( >=kde-frameworks/purpose-${KFMIN}:5 )
	telepathy? ( >=net-libs/telepathy-qt-0.9.8 )
"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS README changelog )

PATCHES=(
	"${WORKDIR}/${P}-optional-purpose.patch" # bug 708464, upstream MR #11
	"${WORKDIR}/${P}-fix-retrieve-twitter.patch" # KDE-bug 417193
	"${WORKDIR}/${P}-choqokplugin.patch"
	"${WORKDIR}/${P}-fix-layout-of-tweets.patch" # KDE-bug 424938
	"${WORKDIR}/${P}-fix-partially-static-signatures.patch" # KDE-bug 417297
	"${FILESDIR}/${P}-fix-KCModule-warning.patch" # bug 871546, git master
)

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package attica KF5Attica)
		-DCMAKE_DISABLE_FIND_PACKAGE_KF5WebKit=ON
		$(cmake_use_find_package share KF5Purpose)
		$(cmake_use_find_package telepathy TelepathyQt5)
	)

	ecm_src_configure
}
