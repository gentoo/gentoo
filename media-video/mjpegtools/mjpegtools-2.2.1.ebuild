# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic multilib-minimal toolchain-funcs

DESCRIPTION="Tools for MJPEG video"
HOMEPAGE="http://mjpeg.sourceforge.net/"
SRC_URI="mirror://sourceforge/mjpeg/${P}.tar.gz"

LICENSE="GPL-2"
# Compare with version in SONAME on major bumps (e.g. 2.1 -> 2.2)
SLOT="1/2.2"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv sparc x86"
IUSE="cpu_flags_x86_mmx dv gtk png quicktime sdl sdlgfx static-libs"
REQUIRED_USE="sdlgfx? ( sdl )"

BDEPEND="
	virtual/pkgconfig
"
RDEPEND="
	virtual/jpeg:0=[${MULTILIB_USEDEP}]
	dv? ( >=media-libs/libdv-1.0.0-r3[${MULTILIB_USEDEP}] )
	gtk? ( x11-libs/gtk+:2 )
	png? ( media-libs/libpng:0= )
	quicktime? ( >=media-libs/libquicktime-1.2.4-r1[${MULTILIB_USEDEP}] )
	sdl? (
		>=media-libs/libsdl-1.2.15-r4[${MULTILIB_USEDEP}]
		>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
		sdlgfx? ( media-libs/sdl-gfx )
	)
"
DEPEND="
	${RDEPEND}
	>=sys-apps/sed-4
	virtual/awk
	cpu_flags_x86_mmx? ( dev-lang/nasm )
"

src_prepare() {
	default

	eautoreconf
	sed -i -e '/ARCHFLAGS=/s:=.*:=:' configure
}

multilib_src_configure() {
	local myconf=(
		--enable-compile-warnings
		$(use_enable cpu_flags_x86_mmx simd-accel)
		$(use_enable static-libs static)
		--enable-largefile

		$(use_with quicktime libquicktime)
		$(use_with dv libdv)
		$(use_with sdl libsdl)
		--without-v4l
		$(use_with sdl x)

		# used by tools only
		$(multilib_native_use_with gtk)
		$(multilib_native_use_with png libpng)
		$(multilib_native_use_with sdlgfx)
	)

	ECONF_SOURCE=${S} \
	econf "${myconf[@]}"
}

multilib_src_compile() {
	if multilib_is_native_abi; then
		default
	else
		# avoid building programs
		emake bin_PROGRAMS=
	fi
}

multilib_src_test() {
	# there are no tests at the moment, so it would just build
	# all programs in non-native ABIs...
	multilib_is_native_abi && default
}

multilib_src_install() {
	if multilib_is_native_abi; then
		default
	else
		emake DESTDIR="${D}" install \
			bin_PROGRAMS=
	fi
}

multilib_src_install_all() {
	einstalldocs
	dodoc mjpeg_howto.txt PLANS HINTS docs/FAQ.txt

	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		elog "mjpegtools installs user contributed scripts which require additional"
		elog "dependencies not pulled in by the installation."
		elog "These have to be installed manually."
		elog "Currently known extra dpendencies are: ffmpeg, mencoder from mplayer,"
		elog "parts of transcode, mpeg2dec from libmpeg2, sox, toolame, vcdimager, python."
	fi
}
