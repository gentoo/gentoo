# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="forceoptional" # FIXME: Check back for doc in release
PVCUT=$(ver_cut 1-3)
KFMIN=5.63.0
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="Import mbox email archives from various sources into Akonadi"

LICENSE="GPL-2+ handbook? ( FDL-1.2+ )"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

DEPEND="
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-apps/akonadi-${PVCUT}:5
	>=kde-apps/kidentitymanagement-${PVCUT}:5
	>=kde-apps/mailcommon-${PVCUT}:5
	>=kde-apps/mailimporter-${PVCUT}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
"
RDEPEND="${DEPEND}
	!kde-apps/kdepim-l10n
	!kde-apps/kmail:4
"
