# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="command line tool to clean and optimize Matroska files"
HOMEPAGE="https://www.matroska.org/downloads/mkclean.html"
SRC_URI="https://downloads.sourceforge.net/project/matroska/${PN}/${P}.tar.bz2"

LICENSE="BSD lzo? ( GPL-2+ )" # minilzo is GPL2+ licensed
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+bzlib +lzo +zlib" # upstream's defaults

# since cmake is used by upstream only for gemerating makefikes
# (it doesn't even install the mkclean binary)
# using cmake eclass is more trouble than it's worth

src_configure() {
	# -Werror=strict-aliasing
	# https://bugs.gentoo.org/861134
	# https://github.com/Matroska-Org/foundation-source/issues/145
	#
	# Do not trust with LTO either.
	append-flags -fno-strict-aliasing
	filter-lto

	# without this flag cmake builds get this error:
	# relocation ... against symbol ... can not be used when making a shared object; recompile with -fPIC
	append-flags -fPIC

	mycmakeargs=(
		-DCONFIG_BZLIB=$(usex bzlib)
		-DCONFIG_LZO1X=$(usex lzo)
		-DCONFIG_ZLIB=$(usex zlib)
		# enables Vorbis frame durations
		-DCONFIG_NOCODEC_HELPER=ON
	)

	tc-export CC CXX
	cmake "${mycmakeargs[@]}" . || die
}

src_install() {
	dobin ${PN}/mk{,WD}clean # NOTE: mkWDclean will be removed in 0.10.0
	newdoc ChangeLog.txt ChangeLog
	newdoc ReadMe.txt README
}
