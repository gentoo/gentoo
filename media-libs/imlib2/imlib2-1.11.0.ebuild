# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Must be bumped with media-plugins/imlib2_loaders!

inherit multilib-minimal toolchain-funcs

DESCRIPTION="Version 2 of an advanced replacement library for libraries like libXpm"
HOMEPAGE="https://www.enlightenment.org/
	https://sourceforge.net/projects/enlightenment/files/imlib2-src/"
SRC_URI="https://downloads.sourceforge.net/enlightenment/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="+X apidoc bzip2 cpu_flags_x86_mmx cpu_flags_x86_sse2 debug
eps +filters +gif +jpeg jpeg2k jpegxl heif lzma mp3 packing +png
+shm static-libs svg +text +tiff +webp zlib"

REQUIRED_USE="shm? ( X )"

RDEPEND="
	X? (
		x11-libs/libX11[${MULTILIB_USEDEP}]
		x11-libs/libXext[${MULTILIB_USEDEP}]
	)
	bzip2? ( app-arch/bzip2[${MULTILIB_USEDEP}] )
	eps? ( app-text/libspectre )
	gif? ( media-libs/giflib:=[${MULTILIB_USEDEP}] )
	heif? ( media-libs/libheif:=[${MULTILIB_USEDEP}] )
	jpeg2k? ( media-libs/openjpeg:=[${MULTILIB_USEDEP}] )
	jpeg? ( media-libs/libjpeg-turbo:=[${MULTILIB_USEDEP}] )
	jpegxl? ( media-libs/libjxl:=[${MULTILIB_USEDEP}] )
	lzma? ( app-arch/xz-utils[${MULTILIB_USEDEP}] )
	media-libs/freetype:2[${MULTILIB_USEDEP}]
	mp3? ( media-libs/libid3tag:=[${MULTILIB_USEDEP}] )
	png? ( >=media-libs/libpng-1.6.10:0=[${MULTILIB_USEDEP}] )
	svg? ( >=gnome-base/librsvg-2.46.0:=[${MULTILIB_USEDEP}] )
	tiff? ( >=media-libs/tiff-4.0.4:=[${MULTILIB_USEDEP}] )
	webp? ( media-libs/libwebp:=[${MULTILIB_USEDEP}] )
	zlib? ( sys-libs/zlib[${MULTILIB_USEDEP}] )
	!<media-plugins/imlib2_loaders-1.10.0
"
DEPEND="${RDEPEND}
	X? ( x11-base/xorg-proto )"
BDEPEND="
	virtual/pkgconfig
	apidoc? ( app-doc/doxygen )
"

# default DOCS will haul README.in we do not need
DOCS=( AUTHORS ChangeLog README TODO )

multilib_src_configure() {
	local myeconfargs=(
		$(use_with X x)
		$(multilib_native_use_enable apidoc doc-build)
		$(use_with bzip2 bz2)
		$(use_enable debug)
		$(multilib_native_use_with eps ps)
		$(use_enable filters)
		$(use_with gif)
		$(use_with heif)
		$(use_with jpeg)
		$(use_with jpeg2k j2k)
		$(use_with jpegxl jxl)
		$(use_with lzma)
		$(use_with mp3 id3)
		$(use_enable packing)
		$(use_with png)
		$(use_with shm x-shm-fd)
		$(use_enable static-libs static)
		$(use_with svg)
		$(use_enable text)
		$(use_with tiff)
		$(use_with webp)
		$(use_with zlib)
	)

	# imlib2 has different configure options for x86/amd64 assembly
	if [[ $(tc-arch) == amd64 ]]; then
		myeconfargs+=( $(use_enable cpu_flags_x86_sse2 amd64) --disable-mmx )
	else
		myeconfargs+=( --disable-amd64 $(use_enable cpu_flags_x86_mmx mmx) )
	fi

	ECONF_SOURCE="${S}" \
	econf "${myeconfargs[@]}"
}

multilib_src_install() {
	V=1 emake install DESTDIR="${D}"
	find "${D}" -name '*.la' -delete || die
	multilib_is_native_abi && use apidoc &&
		export HTML_DOCS=( "${BUILD_DIR}/doc/html/"* )
}
