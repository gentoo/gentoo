# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="forceoptional"
ECM_TEST="true"
KFMIN=5.74.0
QTMIN=5.15.1
inherit ecm kde.org

DESCRIPTION="KDE library for CDDB"

LICENSE="GPL-2+ handbook? ( FDL-1.2 )"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE="musicbrainz"

DEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kcodecs-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	musicbrainz? ( media-libs/musicbrainz:5 )
"
RDEPEND="${DEPEND}"

# tests require network access and compare static data with online data
# bug 280996
RESTRICT+=" test"

src_prepare() {
	ecm_src_prepare

	if ! use handbook ; then
		pushd kcmcddb > /dev/null
		cmake_comment_add_subdirectory doc
		popd > /dev/null
	fi
}

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package musicbrainz MusicBrainz5)
	)

	ecm_src_configure
}
