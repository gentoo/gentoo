# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="true"
inherit kde5

DESCRIPTION="Graphical debugger interface"
HOMEPAGE="http://www.kdbg.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS=""
KEYWORDS="~amd64 ~x86"

COMMON_DEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
"
RDEPEND="${COMMON_DEPEND}
	!dev-util/kdbg:4
	sys-devel/gdb
"
DEPEND="${COMMON_DEPEND}
	media-libs/libpng:0
"

src_prepare() {
	# allow documentation to be handled by eclass
	mv kdbg/doc . || die
	sed -i -e '/add_subdirectory(doc)/d' kdbg/CMakeLists.txt || die
	echo "add_subdirectory ( doc ) " >> CMakeLists.txt || die

	local png
	for png in kdbg/pics/*.png; do
		pngfix -q --out=${png/.png/fixed.png} ${png}
		[[ $? -gt 15 ]] && die "Failed to fix ${png}"
		mv -f ${png/.png/fixed.png} ${png} || die
	done

	kde5_src_prepare
}
