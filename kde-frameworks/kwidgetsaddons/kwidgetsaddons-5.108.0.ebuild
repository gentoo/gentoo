# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_DESIGNERPLUGIN="true"
QTMIN=5.15.9
inherit ecm frameworks.kde.org

DESCRIPTION="An assortment of high-level widgets for common tasks"

LICENSE="LGPL-2.1+"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv x86"
IUSE=""

DEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
"
RDEPEND="${DEPEND}"
BDEPEND=">=dev-qt/linguist-tools-${QTMIN}:5"

src_test() {
	# bug 650216, 653186, 697866, 808216
	local myctestargs=( -E "(kdatecomboboxtest|ksqueezedtextlabelautotest|ktwofingertaptest|ktwofingerswipetest)" )
	ecm_src_test
}
