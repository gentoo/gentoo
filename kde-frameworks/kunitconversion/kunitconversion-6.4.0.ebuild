# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PVCUT=$(ver_cut 1-2)
QTMIN=6.6.2
inherit ecm frameworks.kde.org

DESCRIPTION="Framework for converting units"

LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm64 ~riscv"
IUSE=""

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[network]
	=kde-frameworks/ki18n-${PVCUT}*:6
"
RDEPEND="${DEPEND}"

src_test() {
	local CMAKE_SKIP_TESTS=(
		# bug 623938 - needs internet connection
		convertertest
		# bug 808216 - needs internet connection
		categorytest
		# bug 808216 - unknown, reported upstream
		currencytableinittest
	)

	LC_NUMERIC="C" ecm_src_test # bug 694804
}
