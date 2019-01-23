# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_AUTODEPS="false"
KDE_DEBUG="false"
KDE_QTHELP="false"
inherit kde5

DESCRIPTION="Breeze SVG icon theme"
LICENSE="LGPL-3"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep extra-cmake-modules)
	$(add_qt_dep qtcore)
	test? (
		$(add_qt_dep qttest)
		app-misc/fdupes
	)
"
RDEPEND=""

src_configure() {
	local mycmakeargs=(
		-DBINARY_ICONS_RESOURCE=OFF
	)
	kde5_src_configure
}

src_test() {
	# bug: 655586
	local myctestargs=(
		-j1
		-E "(scalable)"
	)

	kde5_src_test
}
