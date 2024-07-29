# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

MY_P=${PN}-src-${PV}
DESCRIPTION="A fork of Mupen64 Nintendo 64 emulator, SDL audio plugin"
HOMEPAGE="https://www.mupen64plus.org/"
SRC_URI="
	https://github.com/mupen64plus/${PN}/releases/download/${PV}/${MY_P}.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libsamplerate oss speex"

DEPEND="
	>=games-emulation/mupen64plus-core-${PV}:=
	media-libs/libsdl2:0=[sound]
	libsamplerate? ( media-libs/libsamplerate:= )
	speex? (
		media-libs/speex:=
		media-libs/speexdsp:=
	)
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	virtual/pkgconfig
"

src_prepare() {
	default

	# avoid implicitly appending CPU flags
	sed -i -e 's:-mmmx::g' -e 's:-msse::g' projects/unix/Makefile || die
}

src_compile() {
	MAKEARGS=(
		# Note: please keep this in sync in all of mupen64plus-* packages

		-C projects/unix

		# this basically means: GNU userspace
		UNAME=Linux

		# verbose output
		V=1

		CROSS_COMPILE="${CHOST}-"
		CC="$(tc-getCC)"
		CXX="$(tc-getCXX)"
		PKG_CONFIG="$(tc-getPKG_CONFIG)"
		# usual CFLAGS, CXXFLAGS and LDFLAGS are respected
		# so we can leave OPTFLAGS empty
		OPTFLAGS=

		# paths, some of them are used at compile time
		PREFIX=/usr
		LIBDIR=/usr/$(get_libdir)

		# disable unwanted magic
		LDCONFIG=:
		INSTALL_STRIP_FLAG=

		# Package-specific stuff

		# CROSS_COMPILE causes it to look for ${CHOST}-sdl2-config...
		SDL_CFLAGS="$($(tc-getPKG_CONFIG) --cflags sdl2)"
		SDL_LDLIBS="$($(tc-getPKG_CONFIG) --libs sdl2)"

		NO_SPEEX=$(usex speex 0 1)
		NO_SRC=$(usex libsamplerate 0 1)
		NO_OSS=$(usex oss 0 1)
		# not packaged (https://github.com/nemomobile/libaudioresource)
		USE_AUDIORESOURCE=0
	)

	use amd64 && MAKEARGS+=( HOST_CPU=x86_64 )
	use x86 && MAKEARGS+=( HOST_CPU=i386 )

	emake "${MAKEARGS[@]}" all
}

src_install() {
	emake "${MAKEARGS[@]}" DESTDIR="${D}" install
	dodoc RELEASE
}
