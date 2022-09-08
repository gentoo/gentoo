# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_QTHELP="true"
ECM_TEST="true"
PVCUT=$(ver_cut 1-3)
KFMIN=5.96.0
QTMIN=5.15.5
VIRTUALX_REQUIRED="test"
inherit ecm gear.kde.org

DESCRIPTION="Data Model and Extraction System for Travel Reservation information"
HOMEPAGE="https://apps.kde.org/kontact/"

LICENSE="LGPL-2.1+"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE="+barcode"

DEPEND="
	app-text/poppler:=[qt5]
	dev-libs/libphonenumber
	dev-libs/libxml2:2
	dev-libs/openssl:=
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=kde-apps/kmime-${PVCUT}:5
	>=kde-apps/kpkpass-${PVCUT}:5
	>=kde-frameworks/karchive-${KFMIN}:5
	>=kde-frameworks/kcalendarcore-${KFMIN}:5
	>=kde-frameworks/kcontacts-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	sys-libs/zlib
	barcode? ( >=media-libs/zxing-cpp-1.1.0:= )
"
RDEPEND="${DEPEND}"
BDEPEND="x11-misc/shared-mime-info"

src_configure() {
	local mycmakeargs=(
		# sci-geosciences/osmctools; TODO: useful at all?
		-DCMAKE_DISABLE_FIND_PACKAGE_OsmTools=ON
		$(cmake_use_find_package barcode ZXing)
	)
	ecm_src_configure
}
