# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KFMIN=5.69.0
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="Library to support mobipocket ebooks"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~ppc64"
IUSE="+thumbnail"

DEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	thumbnail? ( >=kde-frameworks/kio-${KFMIN}:5 )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DBUILD_thumbnailers=$(usex thumbnail)
	)

	ecm_src_configure
}
