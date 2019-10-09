# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="forceoptional"
inherit kde5

DESCRIPTION="Software to manage quotes and invoices in small enterprises"
HOMEPAGE="http://www.volle-kraft-voraus.de/"
SRC_URI="https://github.com/dragotin/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
IUSE="pim"

DEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	|| (
		$(add_frameworks_dep kcontacts)
		$(add_kdeapps_dep kcontacts)
	)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtsql)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	dev-cpp/ctemplate
	pim? (
		$(add_kdeapps_dep akonadi)
		$(add_kdeapps_dep akonadi-contacts)
	)
"
RDEPEND="${DEPEND}
	!app-office/kraft:4
"

DOCS=( AUTHORS Changes.txt README.md Releasenotes.txt TODO )

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package pim KF5Akonadi)
		$(cmake-utils_use_find_package pim KF5AkonadiContact)
	)

	kde5_src_configure
}
