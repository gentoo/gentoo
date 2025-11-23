# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{13..14} )

inherit autotools python-single-r1 xdg

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/FrodeSolheim/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/FrodeSolheim/${PN}/releases/download/v${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~ppc64"
fi

DESCRIPTION="Integrates the most accurate Amiga emulation code available from WinUAE"
HOMEPAGE="https://fs-uae.net/"
LICENSE="GPL-2"
SLOT="0"
IUSE="glew +jit portmidi"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	app-arch/zstd:=
	dev-libs/glib:2
	media-libs/flac:=
	media-libs/libglvnd
	media-libs/libmpeg2
	media-libs/libpng:0=
	media-libs/libsdl3[opengl]
	media-libs/sdl3-image
	media-libs/sdl3-ttf
	media-sound/mpg123
	virtual/zlib:=
	glew? ( media-libs/glew:0= )
	portmidi? ( media-libs/portmidi )
"

DEPEND="
	${RDEPEND}
"

BDEPEND="
	app-arch/zip
	sys-devel/gettext
	virtual/pkgconfig
"

src_prepare() {
	default
	AT_NO_RECURSIVE=1 eautoreconf
}

src_configure() {
	# Udis86 is unused.
	econf \
		--enable-a2065 \
		--enable-action-replay \
		--enable-aga \
		--enable-arcadia \
		--enable-bsdsocket \
		--enable-caps \
		--enable-cd32 \
		--enable-cdtv \
		--enable-codegen \
		--enable-drivesound \
		--enable-fdi2raw \
		--enable-gfxboard \
		--enable-netplay \
		--enable-ncr \
		--enable-ncr9x \
		--enable-parallel-port \
		--enable-prowizard \
		--enable-savestate \
		--enable-scp \
		--enable-serial-port \
		--enable-slirp \
		--enable-softfloat \
		--enable-qemu-cpu \
		--enable-uaenative \
		--enable-uaenet \
		--enable-uaescsi \
		--enable-uaeserial \
		--disable-udis86 \
		--enable-vpar \
		--enable-xml-shader \
		--with-glad \
		$(use_enable jit) \
		$(use_enable jit jit-fpu) \
		$(use_with glew) \
		$(use_with portmidi midi)
}

src_install() {
	default

	# Needed for QEMU-UAE.
	insinto /usr/include/uae
	doins include/uae/{api,attributes,log,ppc,qemu,types}.h
}
