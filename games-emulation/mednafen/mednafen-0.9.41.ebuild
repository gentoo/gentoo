# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools flag-o-matic pax-utils

DESCRIPTION="Argument-driven multi-system emulator utilizing OpenGL and SDL"
HOMEPAGE="https://mednafen.github.io/"
SRC_URI="https://mednafen.github.io/releases/files/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa altivec cjk debugger jack nls pax_kernel"

RDEPEND="
	dev-libs/libcdio
	media-libs/libsdl[sound,joystick,opengl,video]
	media-libs/libsndfile
	sys-libs/zlib[minizip]
	virtual/opengl
	alsa? ( media-libs/alsa-lib )
	jack? ( media-sound/jack-audio-connection-kit )
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

S=${WORKDIR}/${PN}

PATCHES=(
	"${FILESDIR}"/${PN}-0.9.41-remove-cflags.patch
	"${FILESDIR}"/${PN}-0.9.41-zlib.patch
)

pkg_pretend() {
	if has ccache ${FEATURES}; then
		ewarn
		ewarn "If you experience build failure, try turning off ccache in FEATURES."
		ewarn
	fi
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# very sensitive code (bug #539992)
	strip-flags
	append-flags -fomit-frame-pointer -fwrapv
	econf \
		$(use_enable alsa) \
		$(use_enable altivec) \
		$(use_enable cjk cjk-fonts) \
		$(use_enable debugger) \
		$(use_enable jack) \
		$(use_enable nls)
}

src_install() {
	default
	dodoc Documentation/cheats.txt

	if use pax_kernel; then
		pax-mark m "${ED%/}"/bin/mednafen || die
	fi
}
