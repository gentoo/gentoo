# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=6.9.0
inherit ecm xdg

DESCRIPTION="Quotes and invoices manager for small enterprises"
HOMEPAGE="https://www.volle-kraft-voraus.de/"
SRC_URI="https://github.com/dragotin/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="pim"

RESTRICT="test" # requires package installed, bug 745408

DEPEND="
	dev-qt/qtbase:6[concurrent,gui,network,sql,widgets,xml]
	dev-qt/qtsvg:6
	kde-frameworks/kconfig:6
	kde-frameworks/kcontacts:6
	kde-frameworks/ki18n:6
	kde-frameworks/ktexttemplate:6
	pim? (
		kde-apps/akonadi:6
		kde-apps/akonadi-contacts:6
		kde-frameworks/kcoreaddons:6
	)
"
RDEPEND="${DEPEND}
	!${CATEGORY}/${PN}:5
"

DOCS=( AUTHORS Changes.txt README.md )

PATCHES=(
	"${FILESDIR}/${P}-no-git-or-buildhost-info.patch"
)

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_Asciidoctor=ON # using prebuilt html
		-DGIT_SHA1=${COMMIT}
		-DGIT_BRANCH=master
		-DBUILD_WITH_AKONADI=$(usex pim)
	)
	ecm_src_configure
}
