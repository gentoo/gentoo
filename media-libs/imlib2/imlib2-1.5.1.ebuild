# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib-minimal toolchain-funcs

DESCRIPTION="Version 2 of an advanced replacement library for libraries like libXpm"
HOMEPAGE="https://www.enlightenment.org/"
SRC_URI="https://downloads.sourceforge.net/enlightenment/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bzip2 cpu_flags_x86_mmx cpu_flags_x86_sse2 doc gif jpeg mp3 nls png static-libs tiff X zlib"

RDEPEND="
	media-libs/freetype:2[${MULTILIB_USEDEP}]
	bzip2? ( app-arch/bzip2[${MULTILIB_USEDEP}] )
	gif? ( media-libs/giflib[${MULTILIB_USEDEP}] )
	jpeg? ( ~virtual/jpeg-0:0=[${MULTILIB_USEDEP}] )
	mp3? ( media-libs/libid3tag[${MULTILIB_USEDEP}] )
	nls? ( sys-devel/gettext )
	png? ( >=media-libs/libpng-1.6.10:0=[${MULTILIB_USEDEP}] )
	tiff? ( >=media-libs/tiff-4.0.3-r6:0[${MULTILIB_USEDEP}] )
	X? (
		x11-libs/libX11[${MULTILIB_USEDEP}]
		x11-libs/libXext[${MULTILIB_USEDEP}]
	)
	zlib? ( sys-libs/zlib[${MULTILIB_USEDEP}] )
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig[${MULTILIB_USEDEP}]
	doc? ( app-doc/doxygen )
	X? (
		x11-proto/xextproto[${MULTILIB_USEDEP}]
		x11-proto/xproto[${MULTILIB_USEDEP}]
	)
"

src_prepare() {
	default

	chmod a+rx gendoc || die
}

multilib_src_configure() {
	# imlib2 has diff configure options for x86/amd64 assembly
	if [[ $(tc-arch) == amd64 ]]; then
		local myconf_imlib2=( $(use_enable cpu_flags_x86_sse2 amd64) --disable-mmx )
	else
		local myconf_imlib2=( --disable-amd64 $(use_enable cpu_flags_x86_mmx mmx) )
	fi

	myconf_imlib2+=(
		$(use_with bzip2)
		$(use_with gif)
		$(use_with jpeg)
		$(use_with mp3 id3)
		$(use_with png)
		$(use_enable static-libs static)
		$(use_with tiff)
		$(use_with X x)
		$(use_with zlib)
	)

	ECONF_SOURCE="${S}" \
	econf "${myconf_imlib2[@]}"
}

multilib_src_compile() {
	V=1 emake || die

	if use doc ; then
		if [[ -x ./gendoc ]] ; then
			./gendoc || die

		elif emake -j1 -n doc >&/dev/null ; then
			V=1 emake doc || die

		fi
	fi
}

multilib_src_install() {
	V=1 emake install DESTDIR="${D}" || die

	einstalldocs

	use doc && [[ -d doc ]] && local HTML_DOCS=( doc/. )

	if use static-libs ; then
		find "${D}" -name '*.la' -exec rm -f {} + || die
	fi
}
