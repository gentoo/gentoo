# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_QTHELP="true"
ECM_TEST="true"
PVCUT=$(ver_cut 1-3)
KFMIN=6.22.0
QTMIN=6.10.1
inherit ecm gear.kde.org

DESCRIPTION="Incidence editor for KOrganizer"

LICENSE="GPL-2+"
SLOT="6/$(ver_cut 1-2)"
KEYWORDS="amd64 arm64"
IUSE=""

RDEPEND="
	dev-libs/kdiagram:6
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,widgets]
	>=kde-apps/akonadi-${PVCUT}:6=
	>=kde-apps/akonadi-calendar-${PVCUT}:6=
	>=kde-apps/akonadi-contacts-${PVCUT}:6=
	>=kde-apps/akonadi-mime-${PVCUT}:6=
	>=kde-apps/calendarsupport-${PVCUT}:6=
	>=kde-apps/eventviews-${PVCUT}:6=
	>=kde-apps/kcalutils-${PVCUT}:6=
	>=kde-apps/kidentitymanagement-${PVCUT}:6=
	>=kde-apps/kldap-${PVCUT}:6=
	>=kde-apps/kmime-${PVCUT}:6=
	>=kde-apps/kpimtextedit-${PVCUT}:6=
	>=kde-apps/libkdepim-${PVCUT}:6=
	>=kde-apps/pimcommon-${PVCUT}:6=
	>=kde-frameworks/kcalendarcore-${KFMIN}:6
	>=kde-frameworks/kcodecs-${KFMIN}:6
	>=kde-frameworks/kcompletion-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcontacts-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kguiaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kio-6.22.1:6
	>=kde-frameworks/kitemmodels-${KFMIN}:6
	>=kde-frameworks/kjobwidgets-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
	>=kde-frameworks/ktextwidgets-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
"
DEPEND="${RDEPEND}
	test? ( kde-apps/akonadi-config[mysql,postgres,sqlite] )
"
BDEPEND="
	test? ( >=kde-apps/akonadi-${PVCUT}:6[tools] )
"

src_test() {
	# Paths exceed unix domain socket limit, bugs 770775 and 837182
	local myctestargs=(
		-E "(akonadi-mysql-incidencedatetimetest|akonadi-pgsql-incidencedatetimetest|akonadi-sqlite-incidencedatetimetest)"
	)

	ecm_src_test
}
