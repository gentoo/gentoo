# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
PVCUT=$(ver_cut 1-2)
QTMIN=5.15.5
inherit ecm frameworks.kde.org optfeature python-any-r1

DESCRIPTION="Library for extracting file metadata"

LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="epub exif ffmpeg mobi pdf taglib"

RESTRICT="test"

RDEPEND="
	>=dev-qt/qtxml-${QTMIN}:5
	=kde-frameworks/karchive-${PVCUT}*:5
	=kde-frameworks/kcoreaddons-${PVCUT}*:5
	=kde-frameworks/ki18n-${PVCUT}*:5
	epub? ( app-text/ebook-tools )
	exif? ( media-gfx/exiv2:= )
	ffmpeg? ( media-video/ffmpeg:0= )
	mobi? ( kde-apps/kdegraphics-mobipocket:5 )
	pdf? ( app-text/poppler[qt5] )
	taglib? ( media-libs/taglib )
"
DEPEND="${RDEPEND}
	kernel_linux? ( sys-apps/attr )
"
BDEPEND="test? ( ${PYTHON_DEPS} )"

pkg_setup() {
	use test && python-any-r1_pkg_setup
	ecm_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package epub EPub)
		$(cmake_use_find_package exif LibExiv2)
		$(cmake_use_find_package ffmpeg FFmpeg)
		$(cmake_use_find_package mobi QMobipocket)
		$(cmake_use_find_package pdf Poppler)
		$(cmake_use_find_package taglib Taglib)
	)

	ecm_src_configure
}

src_test() {
	# FIXME: bug 644650, fails on tmpfs (but not for everyone)
	local myctestargs=( -E "(usermetadatawritertest)" )
	ecm_src_test
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		optfeature "Microsoft Word/Powerpoint file indexing" app-text/catdoc
		optfeature "Microsoft Excel file indexing" dev-libs/libxls
	fi
	ecm_pkg_postinst
}
