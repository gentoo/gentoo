# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="forceoptional"
ECM_TEST="forceoptional"
KFMIN=5.60.0
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="Project management application"
HOMEPAGE="https://www.calligra.org/"

if [[ ${KDE_BUILD_TYPE} == release ]]; then
	SRC_URI="mirror://kde/stable/calligra/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="5"
IUSE="activities +holidays kwallet X"

# FIXME: Disabled by upstream for good reason
# Crashes (https://bugs.kde.org/show_bug.cgi?id=311940)
# $(add_kdeapps_dep akonadi)
# $(add_kdeapps_dep akonadi-contacts)
# Currently upstream-disabled:
# =dev-libs/kproperty-3.0*:5
# =dev-libs/kreport-3.0*:5
DEPEND="
	>=dev-qt/designer-${QTMIN}:5
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtprintsupport-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=kde-frameworks/karchive-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/kglobalaccel-${KFMIN}:5
	>=kde-frameworks/kguiaddons-${KFMIN}:5
	>=kde-frameworks/khtml-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kitemviews-${KFMIN}:5
	>=kde-frameworks/kjobwidgets-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/kparts-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/ktextwidgets-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	dev-lang/perl
	dev-libs/kdiagram:5
	activities? ( >=kde-frameworks/kactivities-${KFMIN}:5 )
	holidays? ( >=kde-frameworks/kholidays-${KFMIN}:5 )
	kwallet? (
		app-crypt/qca:2[qt5(+)]
		>=kde-frameworks/kwallet-${KFMIN}:5
	)
	X? (
		>=dev-qt/qtx11extras-${QTMIN}:5
		x11-libs/libX11
	)
"
RDEPEND="${DEPEND}
	!app-office/calligra[calligra_features_plan(-)]
	>=dev-qt/qtsvg-${QTMIN}:5
"

RESTRICT+=" test"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package activities KF5Activities)
		$(cmake_use_find_package holidays KF5Holidays)
		$(cmake_use_find_package kwallet Qca-qt5)
		$(cmake_use_find_package kwallet KF5Wallet)
	)
	# Qt5DBus can't be disabled because of KF5DBusAddons dependency

	ecm_src_configure
}
