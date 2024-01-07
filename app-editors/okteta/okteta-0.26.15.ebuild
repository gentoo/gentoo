# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_DESIGNERPLUGIN="true"
ECM_HANDBOOK="forceoptional"
ECM_TEST="true"
KFMIN=5.92.0
QTMIN=5.15.5
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="Hex editor by KDE"
HOMEPAGE="https://apps.kde.org/okteta/"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
fi

LICENSE="GPL-2 handbook? ( FDL-1.2 )"
SLOT="5"
IUSE="crypt"

DEPEND="
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtprintsupport-${QTMIN}:5
	>=dev-qt/qtscript-${QTMIN}:5[scripttools]
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=kde-frameworks/kbookmarks-${KFMIN}:5
	>=kde-frameworks/kcmutils-${KFMIN}:5
	>=kde-frameworks/kcodecs-${KFMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kjobwidgets-${KFMIN}:5
	>=kde-frameworks/knewstuff-${KFMIN}:5
	>=kde-frameworks/kparts-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	crypt? ( >=app-crypt/qca-2.3.0:2[qt5(+)] )
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}-0.26.13-doctools-optional.patch" ) # downstream

src_configure() {
	local mycmakeargs=(
		-DOMIT_EXAMPLES=ON
		$(cmake_use_find_package crypt Qca-qt5)
	)

	ecm_src_configure
}

src_test() {
	local myctestargs=( -j1 )

	ecm_src_test
}
