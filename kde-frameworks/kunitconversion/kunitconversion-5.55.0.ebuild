# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit kde5

DESCRIPTION="Framework for converting units"
LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep ki18n)
	$(add_qt_dep qtnetwork)
"
RDEPEND="${DEPEND}"

src_test() {
	# bug 623938 - needs internet connection
	local myctestargs=(
		-E "(convertertest)"
	)

	kde5_src_test
}
