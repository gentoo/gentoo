# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multibuild xdg

DESCRIPTION="Atari Running on Any Machine, VM running Atari ST/TT/Falcon OS and TOS/GEM apps"
HOMEPAGE="https://aranym.github.io"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/${PN^^}_${PV//./_}/${PN}_${PV}.orig.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+clipboard +jit jpeg lilo opengl osmesa pmmu +standard usb"
REQUIRED_USE="|| ( jit pmmu standard ) lilo? ( pmmu )"

# LILO can be used without zlib but the zlib dependency is automagic so
# we just require it unconditionally.

RDEPEND="
	dev-libs/gmp:0=
	media-libs/libsdl2[video]
	clipboard? ( !kernel_Winnt? ( x11-libs/libX11 ) )
	jpeg? ( virtual/jpeg )
	kernel_linux? ( virtual/libudev )
	lilo? ( sys-libs/zlib )
	opengl? ( virtual/opengl )
	osmesa? ( media-libs/mesa[osmesa] )
	pmmu? ( dev-libs/mpfr:0= )
	usb? ( virtual/libusb:1 )
"

DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-1.1.0-conditional-installs.patch
)

ECONF_SOURCE="${S}"
DOCS=()

src_prepare() {
	xdg_src_prepare
	eautoreconf
}

src_configure() {
	# standard must come last otherwise the aranym executable gets
	# overwritten by the others.
	MULTIBUILD_VARIANTS=(
		$(usev jit)
		$(usev pmmu)
		$(usev standard)
	)

	multibuild_foreach_variant run_in_build_dir multibuild_src_configure
}

multibuild_src_configure() {
	# jit-fpu doesn't work on some platforms. FPUs were optional in
	# Ataris anyway so just disable.
	local myconf=(
		$(use_enable opengl)
		$(use_enable usb usbhost)
		$(use_enable osmesa nfosmesa)
		$(use_enable jpeg nfjpeg)
		$(use_enable clipboard nfclipbrd)
		--disable-jit-fpu
	)

	if [[ ${MULTIBUILD_VARIANT} == jit ]]; then
		myconf+=( --enable-jit-compiler )
	else
		myconf+=( --disable-jit-compiler )
	fi

	if [[ ${MULTIBUILD_VARIANT} == pmmu ]]; then
		myconf+=( --enable-fullmmu $(use_enable lilo) )
	else
		myconf+=( --disable-fullmmu --disable-lilo )
	fi

	# Force use of SDL2 over SDL1.
	ac_cv_path_SDL_CONFIG=no econf "${myconf[@]}"

	# https://github.com/aranym/aranym/issues/54
	echo "#define HAVE_X11_XLIB_H 1" >> config.h || die
}

src_compile() {
	multibuild_foreach_variant run_in_build_dir default
}

src_install() {
	multibuild_foreach_variant run_in_build_dir default
	rm "${ED}"/usr/share/doc/${PF}/COPYING || die
}
