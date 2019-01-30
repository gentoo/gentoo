# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="An assortment of high-level widgets for common tasks"
LICENSE="LGPL-2.1+"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="nls"

RDEPEND="
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
"
DEPEND="${RDEPEND}
	nls? ( $(add_qt_dep linguist-tools) )
"

PATCHES=( "${FILESDIR}/${P}-no-light-fontstyle-headings.patch" )

src_test() {
	# bug 650216, 653186
	local myctestargs=( -E "(kdatecomboboxtest|ktooltipwidgettest)" )
	kde5_src_test
}
