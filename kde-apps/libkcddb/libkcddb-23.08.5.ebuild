# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
ECM_TEST="true"
KFMIN=5.106.0
QTMIN=5.15.9
inherit ecm gear.kde.org

DESCRIPTION="KDE library for CDDB"

LICENSE="GPL-2+ handbook? ( FDL-1.2 )"
SLOT="5"
KEYWORDS="amd64 arm64 ~ppc64 ~riscv x86"
IUSE="musicbrainz kf6compat"

# tests require network access and compare static data with online data
# bug 280996
RESTRICT="test"

DEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	musicbrainz? ( media-libs/musicbrainz:5 )
"
RDEPEND="${DEPEND}
	kf6compat? ( kde-apps/libkcddb:6 )
"
BDEPEND=">=kde-frameworks/kcmutils-${KFMIN}:5"

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

src_install() {
	ecm_src_install

	if use kf6compat; then
		rm "${D}"/usr/share/applications/kcm_cddb.desktop \
			"${D}"/usr/share/config.kcfg/libkcddb5.kcfg || die
		if use handbook; then
			rm -r "${D}"/usr/share/help || die
		fi
		rm -r "${D}"/usr/share/locale || die
	fi
}
