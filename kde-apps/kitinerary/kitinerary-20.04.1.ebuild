# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_TEST="true"
PVCUT=$(ver_cut 1-3)
KFMIN=5.70.0
QTMIN=5.12.3
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="Data Model and Extraction System for Travel Reservation information"
HOMEPAGE="https://kde.org/applications/office/org.kde.kontact"

LICENSE="LGPL-2.1+"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="+barcode pdf"

DEPEND="
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=kde-frameworks/karchive-${KFMIN}:5
	>=kde-frameworks/kcalendarcore-${KFMIN}:5
	>=kde-frameworks/kcontacts-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-apps/kmime-${PVCUT}:5
	>=kde-apps/kpkpass-${PVCUT}:5
	sys-libs/zlib
	barcode? ( media-libs/zxing-cpp )
	pdf? ( app-text/poppler:=[qt5] )
"
RDEPEND="${DEPEND}
	!<kde-apps/kdepim-addons-18.07.80
"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package barcode ZXing)
		$(cmake_use_find_package pdf Poppler)
	)
	ecm_src_configure
}
