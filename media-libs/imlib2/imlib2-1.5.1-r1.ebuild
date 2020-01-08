# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal toolchain-funcs

DESCRIPTION="Version 2 of an advanced replacement library for libraries like libXpm"
HOMEPAGE="https://www.enlightenment.org/"
SRC_URI="https://downloads.sourceforge.net/enlightenment/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="bzip2 cpu_flags_x86_mmx cpu_flags_x86_sse2 doc gif jpeg mp3 nls png +shm static-libs tiff +X zlib"

REQUIRED_USE="shm? ( X )"

RDEPEND="
	media-libs/freetype:2[${MULTILIB_USEDEP}]
	bzip2? ( app-arch/bzip2[${MULTILIB_USEDEP}] )
	gif? ( media-libs/giflib[${MULTILIB_USEDEP}] )
	jpeg? ( ~virtual/jpeg-0:0=[${MULTILIB_USEDEP}] )
	mp3? ( media-libs/libid3tag[${MULTILIB_USEDEP}] )
	nls? ( sys-devel/gettext )
	png? ( >=media-libs/libpng-1.6.10:0=[${MULTILIB_USEDEP}] )
	tiff? ( >=media-libs/tiff-4.0.4:0[${MULTILIB_USEDEP}] )
	X? (
		x11-libs/libX11[${MULTILIB_USEDEP}]
		x11-libs/libXext[${MULTILIB_USEDEP}]
	)
	zlib? ( sys-libs/zlib[${MULTILIB_USEDEP}] )
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig[${MULTILIB_USEDEP}]
	X? ( x11-base/xorg-proto )
"

multilib_src_configure() {
	local myconf_imlib2=(
		$(use_with bzip2)
		$(use_with gif)
		$(use_with jpeg)
		$(use_with mp3 id3)
		$(use_with png)
		$(use_with shm x-shm-fd)
		$(use_enable static-libs static)
		$(use_with tiff)
		$(use_with X x)
		$(use_with zlib)
	)

	# imlib2 has different configure options for x86/amd64 assembly
	if [[ $(tc-arch) == amd64 ]]; then
		myconf_imlib2+=( $(use_enable cpu_flags_x86_sse2 amd64) --disable-mmx )
	else
		myconf_imlib2+=( --disable-amd64 $(use_enable cpu_flags_x86_mmx mmx) )
	fi

	ECONF_SOURCE="${S}" \
	econf "${myconf_imlib2[@]}"
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
