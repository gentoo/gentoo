# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
PVCUT=$(ver_cut 1-3)
KFMIN=6.3.0
QTMIN=6.6.2
inherit ecm gear.kde.org

DESCRIPTION="KIO worker for accessing audio CDs"

LICENSE="GPL-2+ handbook? ( FDL-1.2 )"
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~riscv"
IUSE="flac vorbis"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[widgets]
	>=kde-apps/libkcddb-${PVCUT}:6
	>=kde-apps/libkcompactdisc-${PVCUT}:6
	>=kde-frameworks/kcompletion-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcmutils-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	media-sound/cdparanoia
	flac? ( >=media-libs/flac-1.1.2:= )
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
