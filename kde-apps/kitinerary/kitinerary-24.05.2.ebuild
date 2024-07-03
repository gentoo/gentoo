# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_QTHELP="true"
ECM_TEST="true"
PVCUT=$(ver_cut 1-3)
KFMIN=6.3.0
QTMIN=6.6.2
inherit ecm gear.kde.org

DESCRIPTION="Data Model and Extraction System for Travel Reservation information"
HOMEPAGE="https://apps.kde.org/kontact/"

LICENSE="LGPL-2.1+"
SLOT="6"
KEYWORDS="~amd64 ~arm64"
IUSE=""

RESTRICT="test" # bug 907957, 851000, 739732...

DEPEND="
	>=app-text/poppler-23.12.0:=[qt6]
	dev-libs/libphonenumber
	dev-libs/libxml2:2
	dev-libs/openssl:=
	>=dev-qt/qtbase-${QTMIN}:6[gui]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=kde-apps/kmime-${PVCUT}:6
	>=kde-apps/kpkpass-${PVCUT}:6
	>=kde-frameworks/karchive-${KFMIN}:6
	>=kde-frameworks/kcalendarcore-${KFMIN}:6
	>=kde-frameworks/kcontacts-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=media-libs/zxing-cpp-1.1.1:=
	sys-libs/zlib
"
RDEPEND="${DEPEND}"
BDEPEND="x11-misc/shared-mime-info"

src_configure() {
	local mycmakeargs=(
		# sci-geosciences/osmctools; TODO: useful at all?
		-DCMAKE_DISABLE_FIND_PACKAGE_OsmTools=ON
	)
	ecm_src_configure
}
