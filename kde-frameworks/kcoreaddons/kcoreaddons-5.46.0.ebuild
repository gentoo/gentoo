# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit kde5

DESCRIPTION="Framework for solving common problems such as caching, randomisation, and more"
LICENSE="LGPL-2+"
KEYWORDS="amd64 ~arm ~arm64 x86"
IUSE="fam nls"

RDEPEND="
	$(add_qt_dep qtcore 'icu')
	fam? ( virtual/fam )
"
DEPEND="${RDEPEND}
	x11-misc/shared-mime-info
	nls? ( $(add_qt_dep linguist-tools) )
"

src_prepare() {
	# bug 650280
	has_version '<dev-qt/qtcore-5.10.0:5' && \
		eapply "${FILESDIR}/${P}-kformattest.patch"

	kde5_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-D_KDE4_DEFAULT_HOME_POSTFIX=4
		$(cmake-utils_use_find_package fam FAM)
	)

	kde5_src_configure
}

src_test() {
	# bugs: 619656, 632398, 647414
	local myctestargs=(
		-j1
		-E "(kautosavefiletest|kdirwatch_qfswatch_unittest)"
	)

	kde5_src_test
}
