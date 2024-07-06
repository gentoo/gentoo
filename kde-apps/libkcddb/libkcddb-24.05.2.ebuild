# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
ECM_TEST="true"
KFMIN=6.3.0
QTMIN=6.6.2
inherit ecm gear.kde.org

DESCRIPTION="KDE library for CDDB"

LICENSE="GPL-2+ handbook? ( FDL-1.2 )"
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~riscv"
IUSE="musicbrainz"

# tests require network access and compare static data with online data
# bug 280996
RESTRICT="test"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui,network,widgets]
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	musicbrainz? ( media-libs/musicbrainz:5 )
"
RDEPEND="${DEPEND}
	!${CATEGORY}/${PN}:5[-kf6compat(-)]
"
BDEPEND=">=kde-frameworks/kcmutils-${KFMIN}:6"

src_prepare() {
	ecm_src_prepare
	use handbook || cmake_run_in kcmcddb cmake_comment_add_subdirectory doc
}

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package musicbrainz MusicBrainz5)
	)

	ecm_src_configure
}
