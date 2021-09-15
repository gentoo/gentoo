# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="forceoptional"
KFMIN=5.60.0
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="Free/Open Source micro-blogging client by KDE"
HOMEPAGE="https://choqok.kde.org/ https://apps.kde.org/choqok/"

if [[ ${KDE_BUILD_TYPE} != live ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${PV%.0}/src/${P}.tar.xz"
	KEYWORDS="amd64 x86"
fi

LICENSE="GPL-2+"
SLOT="5"
IUSE="attica share telepathy"

DEPEND="
	app-crypt/qca[qt5(+)]
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
	telepathy? ( net-libs/telepathy-qt[qt5(+)] )
"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS README changelog )

src_prepare() {
	ecm_src_prepare
	# TODO: quick fix for bug #708464
	sed -e "/find_package.*Purpose)/s/ COMPONENTS //" -i CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package attica KF5Attica)
		-DCMAKE_DISABLE_FIND_PACKAGE_KF5WebKit=ON
		$(cmake_use_find_package share KF5Purpose)
		$(cmake_use_find_package telepathy TelepathyQt5)
	)

	ecm_src_configure
}
