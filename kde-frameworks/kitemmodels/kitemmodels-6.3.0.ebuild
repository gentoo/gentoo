# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QTMIN=6.6.2
inherit ecm frameworks.kde.org

DESCRIPTION="Framework providing data models to help with tasks such as sorting and filtering"

LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm64 ~riscv"

RDEPEND="
	>=dev-qt/qtdeclarative-${QTMIN}:6
"
DEPEND="${RDEPEND}
	test? ( >=dev-qt/qtbase-${QTMIN}:6[widgets] )
"

src_test() {
	LC_NUMERIC="C" ecm_src_test # bug 708820
}
