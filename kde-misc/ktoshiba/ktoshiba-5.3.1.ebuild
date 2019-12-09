# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KFMIN=5.60.0
QTMIN=5.12.3
inherit ecm

DESCRIPTION="Function key (FN) monitoring for Toshiba laptops"
HOMEPAGE="http://ktoshiba.sourceforge.net/"
SRC_URI="http://prdownloads.sourceforge.net/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="5"
KEYWORDS="~amd64"
IUSE=""

BDEPEND="
	sys-devel/gettext
"
DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kauth-${KFMIN}:5
	>=kde-frameworks/kcmutils-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	net-libs/libmnl
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-qt-5.11.patch" )

src_configure() {
	local mycmakeargs=(
		-DLIBMNL_INCLUDE_DIRS=/usr/include/libmnl
	)
	ecm_src_configure
}
