# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal toolchain-funcs

DESCRIPTION="Version 2 of an advanced replacement library for libraries like libXpm"
HOMEPAGE="https://www.enlightenment.org/
	https://sourceforge.net/projects/enlightenment/files/imlib2-src/"
SRC_URI="https://downloads.sourceforge.net/enlightenment/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="+X bzip2 cpu_flags_x86_mmx cpu_flags_x86_sse2 doc +gif +jpeg mp3 +png +shm
	static-libs +tiff +webp zlib"

REQUIRED_USE="shm? ( X )"

RDEPEND="
	media-libs/freetype:2[${MULTILIB_USEDEP}]
	bzip2? ( app-arch/bzip2[${MULTILIB_USEDEP}] )
	gif? ( media-libs/giflib[${MULTILIB_USEDEP}] )
	jpeg? ( virtual/jpeg:0=[${MULTILIB_USEDEP}] )
	mp3? ( media-libs/libid3tag[${MULTILIB_USEDEP}] )
	png? ( >=media-libs/libpng-1.6.10:0=[${MULTILIB_USEDEP}] )
	tiff? ( >=media-libs/tiff-4.0.4:0[${MULTILIB_USEDEP}] )
	webp? ( media-libs/libwebp:=[${MULTILIB_USEDEP}] )
	X? (
		x11-libs/libX11[${MULTILIB_USEDEP}]
		x11-libs/libXext[${MULTILIB_USEDEP}]
	)
	zlib? ( sys-libs/zlib[${MULTILIB_USEDEP}] )
	!<media-plugins/imlib2_loaders-1.6.0
"
DEPEND="${RDEPEND}
	X? ( x11-base/xorg-proto )"
BDEPEND="virtual/pkgconfig"

multilib_src_configure() {
	local myeconfargs=(
		$(use_with X x)
		$(use_with bzip2)
		$(use_with gif)
		$(use_with jpeg)
		$(use_with mp3 id3)
		$(use_with png)
		$(use_with shm x-shm-fd)
		$(use_enable static-libs static)
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
}

multilib_src_install_all() {
	if use doc; then
		local HTML_DOCS=( "${S}"/doc/. )
		rm "${S}"/doc/Makefile.{am,in} || die
	fi
	einstalldocs
}
