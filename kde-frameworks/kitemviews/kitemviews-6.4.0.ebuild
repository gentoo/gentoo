# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_DESIGNERPLUGIN="true"
QTMIN=6.6.2
inherit ecm frameworks.kde.org

DESCRIPTION="Framework providing additional widgets for item models"

LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm64 ~riscv"
IUSE=""

DEPEND=">=dev-qt/qtbase-${QTMIN}:6[gui,widgets]"
RDEPEND="${DEPEND}"
BDEPEND=">=dev-qt/qttools-${QTMIN}:6[linguist]"
