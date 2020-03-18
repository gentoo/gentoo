# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KFMIN=5.60.0
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="Note taking utility by KDE"
HOMEPAGE="https://userbase.kde.org/KJots https://community.kde.org/PIM/KJots"
SRC_URI="mirror://kde/stable/${PN}/${PV}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="5"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtprintsupport-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	dev-libs/grantlee:5
	dev-libs/libxslt
	>=kde-apps/akonadi-19.04.3:5
	>=kde-apps/akonadi-notes-19.04.3:5
	>=kde-apps/kmime-19.04.3:5
	>=kde-apps/kontactinterface-19.04.3:5
	>=kde-apps/kpimtextedit-19.04.3:5
	>=kde-frameworks/kbookmarks-${KFMIN}:5
	>=kde-frameworks/kcmutils-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kitemmodels-${KFMIN}:5
	>=kde-frameworks/kparts-${KFMIN}:5
	>=kde-frameworks/ktextwidgets-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
"
RDEPEND="${DEPEND}
	!app-text/kjots:4
"
