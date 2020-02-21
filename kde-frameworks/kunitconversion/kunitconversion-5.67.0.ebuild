# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PVCUT=$(ver_cut 1-2)
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="Framework for converting units"
LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE=""

DEPEND="
	=kde-frameworks/ki18n-${PVCUT}*:5
	>=dev-qt/qtnetwork-${QTMIN}:5
"
RDEPEND="${DEPEND}"

src_test() {
	# bug 623938 - needs internet connection
	local myctestargs=(
		-E "(convertertest)"
	)

	LC_NUMERIC="C" ecm_src_test # bug 694804
}
