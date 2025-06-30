# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoff"
ECM_TEST="true"
KFMIN=6.13.0
QTMIN=6.7.2
inherit ecm gear.kde.org

DESCRIPTION="KDE library for CDDB"

LICENSE="GPL-2+"
SLOT="6"
KEYWORDS="amd64 ~arm64 ~ppc64 ~riscv ~x86"
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
	>=kde-apps/libkcddb-common-${PV}
"
BDEPEND=">=kde-frameworks/kcmutils-${KFMIN}:6"

# Shipped by kde-apps/libkcddb-common package for shared use w/ SLOT 5
ECM_REMOVE_FROM_INSTALL=(
	/usr/share/applications/kcm_cddb.desktop
	/usr/share/config.kcfg/libkcddb5.kcfg
)

src_prepare() {
	ecm_src_prepare
	ecm_punt_po_install
	cmake_run_in kcmcddb cmake_comment_add_subdirectory doc
}

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package musicbrainz MusicBrainz5)
	)
	ecm_src_configure
}
