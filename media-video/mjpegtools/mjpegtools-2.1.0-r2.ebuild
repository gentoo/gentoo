# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/mjpegtools/mjpegtools-2.1.0-r2.ebuild,v 1.15 2015/05/05 17:02:27 billie Exp $

EAPI=5

inherit autotools eutils flag-o-matic multilib-minimal toolchain-funcs

DESCRIPTION="Tools for MJPEG video"
HOMEPAGE="http://mjpeg.sourceforge.net/"
SRC_URI="mirror://sourceforge/mjpeg/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="1"
KEYWORDS="alpha amd64 ~arm hppa ia64 ppc ppc64 sparc x86 ~amd64-fbsd"
IUSE="dv gtk cpu_flags_x86_mmx png quicktime sdl sdlgfx static-libs"
REQUIRED_USE="sdlgfx? ( sdl )"

RDEPEND="virtual/jpeg:0=[${MULTILIB_USEDEP}]
	quicktime? ( >=media-libs/libquicktime-1.2.4-r1[${MULTILIB_USEDEP}] )
	dv? ( >=media-libs/libdv-1.0.0-r3[${MULTILIB_USEDEP}] )
	png? ( media-libs/libpng:0= )
	gtk? ( x11-libs/gtk+:2 )
	sdl? ( >=media-libs/libsdl-1.2.15-r4[${MULTILIB_USEDEP}]
		>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
		sdlgfx? ( media-libs/sdl-gfx )
	)"

DEPEND="${RDEPEND}
	cpu_flags_x86_mmx? ( dev-lang/nasm )
	>=sys-apps/sed-4
	virtual/awk
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]"

RDEPEND="${RDEPEND}
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-medialibs-20140508-r4
		!app-emulation/emul-linux-x86-medialibs[-abi_x86_32(-)]
	)"

src_prepare() {
	epatch "${FILESDIR}"/${P}-pic.patch
	# https://sourceforge.net/p/mjpeg/bugs/139/
	epatch "${FILESDIR}"/${P}-sdl-cflags.patch
	epatch "${FILESDIR}"/mjpegtools-2.1.0-no_format.patch
	eautoreconf
	sed -i -e '/ARCHFLAGS=/s:=.*:=:' configure
}

multilib_src_configure() {
	[[ $(gcc-major-version) -eq 3 ]] && append-flags -mno-sse2

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

		# used only in V4LCONF_LIBS that is not used anywhere...
		--without-dga
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

	prune_libtool_files --all
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
