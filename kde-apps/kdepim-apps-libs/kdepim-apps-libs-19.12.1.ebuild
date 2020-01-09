# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_TEST="forceoptional"
PVCUT=$(ver_cut 1-3)
KFMIN=5.63.0
QTMIN=5.12.3
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="Libraries for KDE PIM applications"
HOMEPAGE="https://kde.org/applications/office/org.kde.kontact"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

DEPEND="
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcontacts-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/prison-${KFMIN}:5
	>=kde-apps/akonadi-${PVCUT}:5
	>=kde-apps/akonadi-contacts-${PVCUT}:5
	>=kde-apps/grantleetheme-${PVCUT}:5
	>=kde-apps/libkleo-${PVCUT}:5
	>=kde-apps/pimcommon-${PVCUT}:5
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-libs/grantlee-5.1.0:5
"
RDEPEND="${DEPEND}
	!kde-apps/kdepim-l10n
"
