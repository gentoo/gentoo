# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_DESIGNERPLUGIN="true"
ECM_QTHELP="true"
ECM_TEST="forceoptional"
PVCUT=$(ver_cut 1-3)
KFMIN=6.22.0
QTMIN=6.10.1
inherit ecm gear.kde.org

DESCRIPTION="Common mail library"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="6/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm64"
IUSE="activities"

RESTRICT="test"

DEPEND="
	dev-cpp/gpgmepp:=
	dev-libs/qgpgme:=
	>=dev-libs/ktextaddons-1.8.0:6
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,widgets,xml]
	>=dev-qt/qtmultimedia-${QTMIN}:6
	>=kde-apps/akonadi-${PVCUT}:6=
	>=kde-apps/akonadi-contacts-${PVCUT}:6=
	>=kde-apps/akonadi-mime-${PVCUT}:6=
	>=kde-apps/kidentitymanagement-${PVCUT}:6=
	>=kde-apps/kmailtransport-${PVCUT}:6=
	>=kde-apps/kmime-${PVCUT}:6=
	>=kde-apps/kpimtextedit-${PVCUT}:6=
	>=kde-apps/libkdepim-${PVCUT}:6=
	>=kde-apps/mailimporter-${PVCUT}:6=
	>=kde-apps/messagelib-${PVCUT}:6=
	>=kde-apps/pimcommon-${PVCUT}:6=[activities?]
	>=kde-frameworks/karchive-${KFMIN}:6
	>=kde-frameworks/kcodecs-${KFMIN}:6
	>=kde-frameworks/kcolorscheme-${KFMIN}:6
	>=kde-frameworks/kcompletion-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kcontacts-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/kguiaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kio-6.22.1:6
	>=kde-frameworks/kitemmodels-${KFMIN}:6
	>=kde-frameworks/kitemviews-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	>=kde-frameworks/syntax-highlighting-${KFMIN}:6
	activities? ( kde-plasma/plasma-activities:6= )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DOPTION_USE_PLASMA_ACTIVITIES=$(usex activities)
	)
	ecm_src_configure
}
