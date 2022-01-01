# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_TEST="forceoptional"
KDE_ORG_NAME="alkimia"
KFMIN=5.60.0
QTMIN=5.12.3
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/${KDE_ORG_NAME}/${PV}/${KDE_ORG_NAME}-${PV}.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Library with common classes and functionality used by KDE finance applications"
HOMEPAGE="https://www.linux-apps.com/content/show.php/libalkimia?content=137323
https://community.kde.org/Alkimia"

LICENSE="LGPL-2.1"
SLOT="0/8"
IUSE="doc gmp plasma"

BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"
DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kcodecs-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdelibs4support-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/knewstuff-${KFMIN}:5
	>=kde-frameworks/ktextwidgets-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	!gmp? ( sci-libs/mpir:=[cxx] )
	gmp? ( dev-libs/gmp:0=[cxx] )
	plasma? (
		>=kde-frameworks/kpackage-${KFMIN}:5
		>=kde-frameworks/plasma-${KFMIN}:5
	)
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-cmake.patch"
	"${FILESDIR}/${P}-no-financequote.patch"
)

src_configure() {
	local mycmakeargs=(
		-DENABLE_FINANCEQUOTE=OFF
		-DBUILD_WITH_WEBKIT=OFF
		-DBUILD_DOXYGEN_DOCS=$(usex doc)
		$(cmake_use_find_package !gmp MPIR)
		-DBUILD_APPLETS=$(usex plasma)
	)
	ecm_src_configure
}

src_test() {
	# Depends on BUILD_WITH_WEBKIT, bug 736128
	local myctestargs=(
		-E "(alkonlinequotestest)"
	)
	ecm_src_test
}
