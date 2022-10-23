# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
PVCUT=$(ver_cut 1-3)
KFMIN=5.96.0
QTMIN=5.15.5
inherit ecm gear.kde.org

DESCRIPTION="KIO worker for accessing audio CDs"

LICENSE="GPL-2+ handbook? ( FDL-1.2 )"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="flac vorbis"

DEPEND="
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-apps/libkcddb-${PVCUT}:5
	>=kde-apps/libkcompactdisc-${PVCUT}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcmutils-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
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
