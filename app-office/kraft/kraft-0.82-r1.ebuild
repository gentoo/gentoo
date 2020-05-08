# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="forceoptional"
KFMIN=5.60.0
QTMIN=5.12.3
inherit ecm

DESCRIPTION="Software to manage quotes and invoices in small enterprises"
HOMEPAGE="https://www.volle-kraft-voraus.de/"
SRC_URI="https://github.com/dragotin/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+ LGPL-2+"
SLOT="5"
KEYWORDS="~amd64 ~x86"
IUSE="pim"

DEPEND="
	dev-cpp/ctemplate
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtsql-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	|| (
		>=kde-frameworks/kcontacts-${KFMIN}:5
		>=kde-apps/kcontacts-19.04.3:5
	)
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	pim? (
		>=kde-apps/akonadi-19.04.3:5
		>=kde-apps/akonadi-contacts-19.04.3:5
	)
"
RDEPEND="${DEPEND}
	!app-office/kraft:4
"

DOCS=( AUTHORS Changes.txt README.md Releasenotes.txt TODO )

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package pim KF5Akonadi)
		$(cmake_use_find_package pim KF5AkonadiContact)
	)

	ecm_src_configure
}
