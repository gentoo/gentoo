# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_DESIGNERPLUGIN="true"
ECM_PYTHON_BINDINGS="off"
QTMIN=6.7.2
inherit ecm frameworks.kde.org

DESCRIPTION="An assortment of high-level widgets for common tasks"

LICENSE="LGPL-2.1+"
KEYWORDS="~amd64 arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE=""

DEPEND=">=dev-qt/qtbase-${QTMIN}:6[gui,widgets]"
RDEPEND="${DEPEND}"
BDEPEND=">=dev-qt/qttools-${QTMIN}:6[linguist]"

CMAKE_SKIP_TESTS=(
	# bug 650216
	kdatecomboboxtest
	# bug 697866
	ksqueezedtextlabelautotest
	# bug 926508
	ktooltipwidgettest
	# bug 808216
	ktwofingertaptest
	ktwofingerswipetest
)
