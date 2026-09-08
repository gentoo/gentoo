# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

DESCRIPTION="Command line tool to clean and optimize Matroska files"
HOMEPAGE="https://www.matroska.org/downloads/mkclean.html"
SRC_URI="https://downloads.sourceforge.net/project/matroska/${PN}/${P}.tar.bz2"

LICENSE="BSD lzo? ( GPL-2+ )" # minilzo is GPL2+ licensed
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+bzlib +lzo +zlib" # upstream's defaults

DOCS=( {ChangeLog,ReadMe}.txt )

src_configure() {
	# -Werror=strict-aliasing
	# https://bugs.gentoo.org/861134
	# https://github.com/Matroska-Org/foundation-source/issues/145
	#
	# Do not trust with LTO either.
	append-flags -fno-strict-aliasing
	filter-lto

	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=OFF # to not add -fPIC for relocation
		-DCONFIG_BZLIB=$(usex bzlib)
		-DCONFIG_LZO1X=$(usex lzo)
		-DCONFIG_ZLIB=$(usex zlib)
		# enables Vorbis frame durations
		-DCONFIG_NOCODEC_HELPER=ON
	)

	cmake_src_configure
}

src_install() {
	dobin "${BUILD_DIR}"/${PN}/${PN}
	dobin "${BUILD_DIR}"/${PN}/mkWDclean # NOTE: this will be removed in 0.10.0
	einstalldocs
}
