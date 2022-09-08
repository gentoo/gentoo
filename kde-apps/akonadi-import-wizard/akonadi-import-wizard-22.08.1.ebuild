# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
PVCUT=$(ver_cut 1-3)
KFMIN=5.96.0
QTMIN=5.15.5
inherit ecm gear.kde.org

DESCRIPTION="Assistant to import PIM data from other applications into Akonadi"
HOMEPAGE+=" https://userbase.kde.org/KMail/Import_Options"

LICENSE="GPL-2+ handbook? ( FDL-1.2+ )"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE=""

DEPEND="
	dev-libs/qtkeychain:=
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=kde-apps/akonadi-${PVCUT}:5
	>=kde-apps/kidentitymanagement-${PVCUT}:5
	>=kde-apps/kmailtransport-${PVCUT}:5
	>=kde-apps/mailcommon-${PVCUT}:5
	>=kde-apps/mailimporter-${PVCUT}:5
	>=kde-apps/messagelib-${PVCUT}:5
	>=kde-apps/pimcommon-${PVCUT}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kcontacts-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
"
RDEPEND="${DEPEND}"
