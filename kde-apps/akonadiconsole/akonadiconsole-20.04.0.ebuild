# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="forceoptional" # FIXME: Check back for doc in release
PVCUT=$(ver_cut 1-3)
KFMIN=5.69.0
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="Application for debugging Akonadi Resources"
HOMEPAGE="https://techbase.kde.org/KDE_PIM/Akonadi/Development_Tools"

LICENSE="GPL-2+ LGPL-2.1+ handbook? ( FDL-1.2+ )"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

DEPEND="
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kitemmodels-${KFMIN}:5
	>=kde-frameworks/kitemviews-${KFMIN}:5
	>=kde-frameworks/ktextwidgets-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-apps/akonadi-${PVCUT}:5
	>=kde-apps/akonadi-contacts-${PVCUT}:5
	>=kde-apps/akonadi-search-${PVCUT}:5
	>=kde-apps/calendarsupport-${PVCUT}:5
	>=kde-frameworks/kcalendarcore-${KFMIN}:5
	>=kde-frameworks/kcontacts-${KFMIN}:5
	>=kde-apps/kmime-${PVCUT}:5
	>=kde-apps/libkdepim-${PVCUT}:5
	>=kde-apps/messagelib-${PVCUT}:5
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtsql-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	dev-libs/xapian:=
"
RDEPEND="${DEPEND}"
