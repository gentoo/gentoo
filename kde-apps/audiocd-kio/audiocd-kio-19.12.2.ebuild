# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="forceoptional"
PVCUT=$(ver_cut 1-3)
KFMIN=5.63.0
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="kioslave for accessing audio CDs"

LICENSE="GPL-2+ handbook? ( FDL-1.2 )"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="flac vorbis"

DEPEND="
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcmutils-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-apps/libkcddb-${PVCUT}:5
	>=kde-apps/libkcompactdisc-${PVCUT}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	media-sound/cdparanoia
	flac? ( >=media-libs/flac-1.1.2 )
	vorbis? (
		media-libs/libogg
		media-libs/libvorbis
	)
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}-19.04.0-handbook.patch" )

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package flac FLAC)
		$(cmake_use_find_package vorbis OggVorbis)
	)

	ecm_src_configure
}
