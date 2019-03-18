# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit kde5

DESCRIPTION="Framework for solving common problems such as caching, randomisation, and more"
LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="fam nls"

BDEPEND="
	nls? ( $(add_qt_dep linguist-tools) )
"
DEPEND="
	$(add_qt_dep qtcore 'icu')
	fam? ( virtual/fam )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-D_KDE4_DEFAULT_HOME_POSTFIX=4
		$(cmake-utils_use_find_package fam FAM)
	)

	kde5_src_configure
}

src_test() {
	# bugs: 619656, 632398, 647414, 665682
	local myctestargs=(
		-j1
		-E "(kautosavefiletest|kdirwatch_qfswatch_unittest|kformattest)"
	)

	kde5_src_test
}
