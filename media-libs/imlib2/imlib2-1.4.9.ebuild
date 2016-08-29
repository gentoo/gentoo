# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

EGIT_SUB_PROJECT="legacy"
EGIT_URI_APPEND=${PN}

if [[ ${PV} != "9999" ]] ; then
	EKEY_STATE="snap"
fi

inherit enlightenment toolchain-funcs multilib-minimal eutils

DESCRIPTION="Version 2 of an advanced replacement library for libraries like libXpm"
HOMEPAGE="https://www.enlightenment.org/"

KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-solaris ~x86-solaris"

IUSE="bzip2 gif jpeg cpu_flags_x86_mmx cpu_flags_x86_sse2 mp3 png static-libs tiff X zlib"

RDEPEND="=media-libs/freetype-2*[${MULTILIB_USEDEP}]
	bzip2? ( >=app-arch/bzip2-1.0.6-r4[${MULTILIB_USEDEP}] )
	zlib? ( >=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}] )
	gif? ( >=media-libs/giflib-4.1.6-r3[${MULTILIB_USEDEP}] )
	png? ( >=media-libs/libpng-1.6.10:0[${MULTILIB_USEDEP}] )
	jpeg? ( >=virtual/jpeg-0-r2:0[${MULTILIB_USEDEP}] )
	tiff? ( >=media-libs/tiff-4.0.3-r6:0[${MULTILIB_USEDEP}] )
	X? (
		>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXext-1.3.2[${MULTILIB_USEDEP}]
	)
	mp3? ( >=media-libs/libid3tag-0.15.1b-r3[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
	X? (
		>=x11-proto/xextproto-7.2.1-r1[${MULTILIB_USEDEP}]
		>=x11-proto/xproto-7.0.24[${MULTILIB_USEDEP}]
	)"

multilib_src_configure() {
	# imlib2 has diff configure options for x86/amd64 assembly
	if [[ $(tc-arch) == amd64 ]]; then
		E_ECONF+=( $(use_enable cpu_flags_x86_sse2 amd64) --disable-mmx )
	else
		E_ECONF+=( --disable-amd64 $(use_enable cpu_flags_x86_mmx mmx) )
	fi

	[[ $(gcc-major-version) -ge 4 ]] && E_ECONF+=( --enable-visibility-hiding )

	ECONF_SOURCE="${S}" \
	E_ECONF+=(
		$(use_enable static-libs static)
		$(use_with X x)
		$(use_with jpeg)
		$(use_with png)
		$(use_with tiff)
		$(use_with gif)
		$(use_with zlib)
		$(use_with bzip2)
		$(use_with mp3 id3)
	)

	enlightenment_src_configure
}

multilib_src_install() {
	enlightenment_src_install
}
