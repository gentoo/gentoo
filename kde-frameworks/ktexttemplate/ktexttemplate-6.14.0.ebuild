# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="true"
QTMIN=6.7.2
inherit ecm frameworks.kde.org

DESCRIPTION="Library to allow separating the structure of documents from data they contain"

LICENSE="LGPL-2.1+"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE=""

RDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui]
	dev-qt/qtdeclarative:6
"
DEPEND="${RDEPEND}"
BDEPEND="test? ( dev-qt/qttools:6[linguist] )"
