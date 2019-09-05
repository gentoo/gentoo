# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit kde5

DESCRIPTION="Framework providing access to Open Collaboration Services"
LICENSE="LGPL-2.1+"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

RDEPEND="
	$(add_qt_dep qtnetwork)
"
DEPEND="${RDEPEND}"

src_test() {
	# requires network access, bug #661230
	local myctestargs=(
		-E "(providertest)"
	)

	kde5_src_test
}
