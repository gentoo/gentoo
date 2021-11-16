# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="true"
PVCUT=$(ver_cut 1-3)
KFMIN=5.84.0
QTMIN=5.15.2
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="Incidence editor for korganizer"

LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE=""

RDEPEND="
	dev-libs/kdiagram:5
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-apps/akonadi-${PVCUT}:5
	>=kde-apps/akonadi-calendar-${PVCUT}:5
	>=kde-apps/akonadi-contacts-${PVCUT}:5
	>=kde-apps/akonadi-mime-${PVCUT}:5
	>=kde-apps/calendarsupport-${PVCUT}:5
	>=kde-apps/eventviews-${PVCUT}:5
	>=kde-apps/kcalutils-${PVCUT}:5
	>=kde-apps/kidentitymanagement-${PVCUT}:5
	>=kde-apps/kldap-${PVCUT}:5
	>=kde-apps/kmailtransport-${PVCUT}:5
	>=kde-apps/kmime-${PVCUT}:5
	>=kde-apps/libkdepim-${PVCUT}:5
	>=kde-apps/pimcommon-${PVCUT}:5
	>=kde-frameworks/kcalendarcore-${KFMIN}:5
	>=kde-frameworks/kcodecs-${KFMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcontacts-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kitemmodels-${KFMIN}:5
	>=kde-frameworks/kjobwidgets-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/ktextwidgets-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
"
DEPEND="${RDEPEND}
	test? ( >=kde-apps/akonadi-${PVCUT}:5[postgres,sqlite] )
"
BDEPEND="
	test? ( >=kde-apps/akonadi-${PVCUT}:5[tools] )
"

src_prepare() {
	ecm_src_prepare
	ecm_punt_bogus_dep KF5 GrantleeTheme
}

src_configure() {
	local mycmakeargs=(
		-DKDEPIM_RUN_AKONADI_TEST=OFF
	)
	ecm_src_configure
}

src_test() {
	# Paths exceed unix domain socket limit, bug 770775
	local myctestargs=(
		-E "(akonadi-pgsql-incidencedatetimetest|akonadi-sqlite-incidencedatetimetest)"
	)

	ecm_src_test
}
