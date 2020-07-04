# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools flag-o-matic pax-utils

DESCRIPTION="Argument-driven multi-system emulator utilizing OpenGL and SDL"
HOMEPAGE="https://mednafen.github.io/"
SRC_URI="https://mednafen.github.io/releases/files/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa altivec cjk debugger jack nls"

RDEPEND="
	dev-libs/libcdio
	>=dev-libs/lzo-2.10
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

pkg_pretend() {
	if has ccache ${FEATURES}; then
		ewarn
		ewarn "If you experience build failure, try turning off ccache in FEATURES."
		ewarn
	fi
}

src_prepare() {
	default

	# Unfortunately, upstream is insane and thinks mucking with CFLAGS is okay, if
	# it prevents "users who don't understand the consequences of what they're doing".
	# We use sed's here, as they're more forward-compatible than patches which need to
	# be constantly rebased. DO NOT REPLACE THEM UNLESS YOU HAVE PERMISSION FROM GAMES.
	sed -e '/-fno-fast-math/d' \
		-e '/-fno-unsafe-math-optimizations/d' \
		-e '/-fno-aggressive-loop-optimizations/d' \
		-e '/-fno-ipa-icf/d' \
		-e '/-fno-printf-return-value/d' \
		-e '/-fomit-frame-pointer/d' \
		-e '/-fno-pic/d' \
		-e '/-fno-pie/d' \
		-e '/-fno-PIC/d' \
		-e '/-fno-PIE/d' \
		-e '/-nopie/d' \
		-e '/-no-pie/d' \
		-e '/-fno-stack-protector/d' \
		-e '/-fno-stack-protector-all/d' \
		-e '/-fno-stack-protector-strong/d' \
		-e '/-mtune=haswell/d' \
		-i configure.ac || die

	# Furthermore, upstream is also insane about bundling libraries and considers it
	# "an aesthetics issue" and is even unwilling to make unbundling optional.
	# Libs to unbundle: minilzo, minizip
	sed -e '/PKG_PROG_PKG_CONFIG/a PKG_CHECK_MODULES([LZO], [lzo2])' \
		-i configure.ac || die
	sed -e '/bin_PROGRAMS/a mednafen_CPPFLAGS = \$(LZO_CFLAGS)' \
		-i src/Makefile.am || die
	sed -e 's:"compress/minilzo.h":<lzo1x.h>:' \
		-i src/{mednafen,qtrecord}.cpp || die
	sed -e 's:compress/ioapi.c::' \
		-e 's:compress/unzip.c::' \
		-e 's:compress/minilzo.c::' \
		-i src/compress/Makefile.am.inc || die
	sed -e 's:"compress/unzip.h":<minizip/unzip.h>:' \
		-i src/file.cpp || die
	sed -e 's:\(mednafen_LDADD.*trio/libtrio\.a\):\1 -lminizip \$(LZO_LIBS):' \
		-i src/Makefile.am || die
	# delete bundled files just to be sure...
	rm src/compress/{ioapi.?,*lzo*,unzip.?} || die

	# The insanity continues... upstream now believes it needs to
	# warn users when compiling with -fPIC/-fPIE enabled
	sed -e '/Compiling with position-independent code generation enabled is not recommended, for performance reasons/d' \
		-i src/types.h || die

	eautoreconf
}

src_configure() {
	# very dodgy code (bug #539992)
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
	pax-mark m "${ED}"usr/bin/mednafen
}
