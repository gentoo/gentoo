# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_DESIGNERPLUGIN="true"
QTMIN=5.15.9
inherit ecm frameworks.kde.org

DESCRIPTION="An assortment of high-level widgets for common tasks"

LICENSE="LGPL-2.1+"
KEYWORDS="amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE=""

DEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
"
RDEPEND="${DEPEND}"
BDEPEND=">=dev-qt/linguist-tools-${QTMIN}:5"

CMAKE_SKIP_TESTS=(
	# bug 650216
	kdatecomboboxtest
	# bug 697866
	ksqueezedtextlabelautotest
	# bug 808216
	ktwofingertaptest
	ktwofingerswipetest
)
