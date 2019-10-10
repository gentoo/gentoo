# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit kde5

DESCRIPTION="Library to support mobipocket ebooks"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="+thumbnail"

DEPEND="
	$(add_qt_dep qtgui)
	thumbnail? ( $(add_frameworks_dep kio) )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DBUILD_thumbnailers=$(usex thumbnail)
	)

	kde5_src_configure
}
