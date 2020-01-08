# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils multilib-minimal

DESCRIPTION="C library for image processing and analysis"
HOMEPAGE="http://www.leptonica.org/"
SRC_URI="https://github.com/DanBloomberg/${PN}/releases/download/${PV}/${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0/5"
KEYWORDS="alpha amd64 arm arm64 ~mips ppc ppc64 ~sparc x86 ~ppc-macos"
IUSE="gif jpeg jpeg2k png static-libs test tiff utils webp zlib"
RESTRICT="!test? ( test )"

# N.B. Tests need some features enabled:
REQUIRED_USE="test? ( jpeg png tiff zlib )"

DEPEND="gif? ( media-libs/giflib:=[${MULTILIB_USEDEP}] )
	jpeg? ( virtual/jpeg:0=[${MULTILIB_USEDEP}] )
	jpeg2k? ( media-libs/openjpeg:2=[${MULTILIB_USEDEP}] )
	png? ( media-libs/libpng:0=[${MULTILIB_USEDEP}]
		   sys-libs/zlib:=[${MULTILIB_USEDEP}] )
	tiff? ( media-libs/tiff:0=[${MULTILIB_USEDEP}] )
	webp? ( media-libs/libwebp:=[${MULTILIB_USEDEP}] )
	zlib? ( sys-libs/zlib:=[${MULTILIB_USEDEP}] )"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/baseline_reg.patch )
ECONF_SOURCE="${S}"
DOCS=( README version-notes )

src_prepare() {
	default

	# unhtmlize docs
	local X
	for X in ${DOCS[@]}; do
		awk '/<\/pre>/{s--} {if (s) print $0} /<pre>/{s++}' \
			"${X}.html" > "${X}" || die 'awk failed'
		rm -f -- "${X}.html"
	done
}

multilib_src_configure() {
	econf \
		--enable-shared \
		$(use_with gif giflib) \
		$(use_with jpeg) \
		$(use_with jpeg2k libopenjpeg) \
		$(use_with png libpng) \
		$(use_with tiff libtiff) \
		$(use_with webp libwebp) \
		$(use_with zlib) \
		$(use_enable static-libs static) \
		$(multilib_native_use_enable utils programs)
}

src_install() {
	multilib-minimal_src_install
	prune_libtool_files
}
