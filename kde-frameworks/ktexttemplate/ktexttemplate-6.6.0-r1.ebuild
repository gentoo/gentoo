# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="true"
PVCUT=$(ver_cut 1-2)
QTMIN=6.6.2
inherit ecm flag-o-matic frameworks.kde.org

DESCRIPTION="Library to allow separating the structure of documents from data they contain"

LICENSE="LGPL-2.1+"
KEYWORDS="amd64 arm64 ~ppc64 ~riscv ~x86"
IUSE=""

RDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui]
	dev-qt/qtdeclarative:6
"
DEPEND="${RDEPEND}"
BDEPEND="test? ( dev-qt/qttools:6[linguist] )"

src_configure() {
	# https://gcc.gnu.org/PR116783
	use arm64 && append-flags $(test-flags-CXX -mno-late-ldp-fusion)

	ecm_src_configure
}
