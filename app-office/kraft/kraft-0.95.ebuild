# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VIRTUALX_REQUIRED="test"
inherit ecm

DESCRIPTION="Software to manage quotes and invoices in small enterprises"
HOMEPAGE="https://www.volle-kraft-voraus.de/"
SRC_URI="https://github.com/dragotin/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+ LGPL-2+"
SLOT="5"
KEYWORDS="~amd64 ~x86"
IUSE="pim"

RESTRICT+=" test" # requires package installed, bug 745408

DEPEND="
	dev-cpp/ctemplate
	dev-libs/grantlee:5
	dev-qt/qtgui:5
	dev-qt/qtsql:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	kde-frameworks/kconfig:5
	kde-frameworks/kcontacts:5
	kde-frameworks/ki18n:5
	pim? (
		>=kde-apps/akonadi-19.04.3:5
		>=kde-apps/akonadi-contacts-19.04.3:5
		kde-frameworks/kcoreaddons:5
	)
"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS Changes.txt README.md Releasenotes.txt TODO )

PATCHES=( "${FILESDIR}/${P}-i18n-warning.patch" )

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_Asciidoctor=ON
		$(cmake_use_find_package pim KF5Akonadi)
		$(cmake_use_find_package pim KF5AkonadiContact)
	)

	ecm_src_configure
}
