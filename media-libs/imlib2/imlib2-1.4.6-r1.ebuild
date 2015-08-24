# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

EGIT_SUB_PROJECT="legacy"
EGIT_URI_APPEND=${PN}

if [[ ${PV} != "9999" ]] ; then
	EKEY_STATE="snap"
fi

inherit enlightenment toolchain-funcs

DESCRIPTION="Version 2 of an advanced replacement library for libraries like libXpm"
HOMEPAGE="https://www.enlightenment.org/"

IUSE="bzip2 gif jpeg cpu_flags_x86_mmx mp3 png static-libs tiff X zlib"

RDEPEND="=media-libs/freetype-2*
	bzip2? ( app-arch/bzip2 )
	zlib? ( sys-libs/zlib )
	gif? ( >=media-libs/giflib-4.1.0 )
	png? ( media-libs/libpng:0 )
	jpeg? ( virtual/jpeg:0 )
	tiff? ( media-libs/tiff:0 )
	X? (
		x11-libs/libX11
		x11-libs/libXext
	)
	mp3? ( media-libs/libid3tag )"
DEPEND="${RDEPEND}
	png? ( virtual/pkgconfig )
	X? (
		x11-proto/xextproto
		x11-proto/xproto
	)"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.4.5-no-my-libs.patch #497894
	epatch "${FILESDIR}"/${PN}-1.4.5-giflib-5.patch #457634
}

src_configure() {
	# imlib2 has diff configure options for x86/amd64 mmx
	if [[ $(tc-arch) == amd64 ]]; then
		E_ECONF+=( $(use_enable cpu_flags_x86_mmx amd64) --disable-mmx )
	else
		E_ECONF+=( --disable-amd64 $(use_enable cpu_flags_x86_mmx mmx) )
	fi

	[[ $(gcc-major-version) -ge 4 ]] && E_ECONF+=( --enable-visibility-hiding )

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

src_install() {
	enlightenment_src_install

	# enlightenment_src_install should take care of this for us, but it doesn't
	find "${ED}" -name '*.la' -delete
}
