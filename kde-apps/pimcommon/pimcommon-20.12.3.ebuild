# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_DESIGNERPLUGIN="true"
ECM_TEST="forceoptional"
PVCUT=$(ver_cut 1-3)
KFMIN=5.75.0
QTMIN=5.15.2
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="Common PIM libraries"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="5"
KEYWORDS="amd64 arm64 ~ppc64 x86"
IUSE=""

BDEPEND="
	dev-libs/libxslt
"
COMMON_DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtprintsupport-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=kde-apps/akonadi-${PVCUT}:5
	>=kde-apps/akonadi-contacts-${PVCUT}:5
	>=kde-apps/akonadi-search-${PVCUT}:5
	>=kde-apps/kimap-${PVCUT}:5
	>=kde-apps/kldap-${PVCUT}:5
	>=kde-apps/kpimtextedit-${PVCUT}:5
	>=kde-apps/libkdepim-${PVCUT}:5
	>=kde-frameworks/karchive-${KFMIN}:5
	>=kde-frameworks/kcmutils-${KFMIN}:5
	>=kde-frameworks/kcodecs-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcontacts-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kitemmodels-${KFMIN}:5
	>=kde-frameworks/kjobwidgets-${KFMIN}:5
	>=kde-frameworks/knewstuff-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-frameworks/purpose-${KFMIN}:5
"
DEPEND="${COMMON_DEPEND}
	test? ( >=kde-apps/kmime-${PVCUT}:5 )
"
RDEPEND="${COMMON_DEPEND}
	!<kde-apps/libkdepim-20.07.80:5
"

src_test() {
	# bugs 641730, 661330
	local myctestargs=(
		-E "(autocorrectiontest|pimcommon-translator-translatortest)"
	)

	ecm_src_test
}
