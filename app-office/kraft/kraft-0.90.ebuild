# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="forceoptional"
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
	dev-qt/qtgui:5
	dev-qt/qtsql:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	kde-frameworks/kconfig:5
	kde-frameworks/kconfigwidgets:5
	kde-frameworks/kcontacts:5
	kde-frameworks/kcoreaddons:5
	kde-frameworks/ki18n:5
	pim? (
		kde-apps/akonadi:5
		kde-apps/akonadi-contacts:5
	)
"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS Changes.txt README.md Releasenotes.txt TODO )

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package pim KF5Akonadi)
		$(cmake_use_find_package pim KF5AkonadiContact)
	)

	ecm_src_configure
}
