# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_DESIGNERPLUGIN="true"
QTMIN=5.12.3
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="An assortment of high-level widgets for common tasks"
LICENSE="LGPL-2.1+"
KEYWORDS="amd64 ~arm arm64 ~ppc64 x86"
IUSE="nls"

# drop qtgui subslot operator when QT_MINIMAL >= 5.14.0
BDEPEND="
	nls? ( >=dev-qt/linguist-tools-${QTMIN}:5 )
"
DEPEND="
	>=dev-qt/qtgui-${QTMIN}:5=
	>=dev-qt/qtwidgets-${QTMIN}:5
"
RDEPEND="${DEPEND}"

src_test() {
	# bug 650216, 653186, 697866
	local myctestargs=( -E "(kdatecomboboxtest|ksqueezedtextlabelautotest)" )
	ecm_src_test
}
