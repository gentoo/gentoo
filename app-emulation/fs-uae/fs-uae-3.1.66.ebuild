# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic xdg

DESCRIPTION="Integrates the most accurate Amiga emulation code available from WinUAE"
HOMEPAGE="https://fs-uae.net/"
SRC_URI="https://fs-uae.net/files/FS-UAE/Stable/${PV}/${P}.tar.xz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"
IUSE="fmv glew +jit"

RDEPEND="
	dev-libs/glib:2
	media-libs/libpng:0=
	media-libs/libsdl2[opengl,X]
	media-libs/openal
	sys-libs/zlib
	virtual/opengl
	x11-libs/libdrm
	x11-libs/libX11
	fmv? ( media-libs/libmpeg2 )
	glew? ( media-libs/glew:0= )
"

DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"

BDEPEND="
	app-arch/zip
	sys-devel/gettext
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-3.0.0-libmpeg2.patch
	"${FILESDIR}"/${PN}-3.0.0-Xatom.h.patch
	"${FILESDIR}"/${PN}-3.1.35-deepbind.patch
	"${FILESDIR}"/${PN}-3.1.66-musl.patch
)

src_prepare() {
	default
	AT_NO_RECURSIVE=1 eautoreconf

	# Ensure bundled libraries are not used. Udis86 is unused
	# regardless. Only FLAC headers are bundled and the library is never
	# used? Lua is bundled but differs from upstream. We keep the
	# default of disabling the Lua feature anyway as it is unfinished.
	rm -r libmpeg2/ libudis86/ || die
}

src_configure() {
	# -Werror=odr -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/854519
	#
	# Fixed upstream in git master but no releases since 2021 and no activity since 2022.
	filter-lto

	# Qt and Udis86 are unused.
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
		--enable-dms \
		--enable-drivesound \
		--enable-fdi2raw \
		--enable-gfxboard \
		--disable-lua \
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
		--enable-qemu-slirp \
		--enable-uaenative \
		--enable-uaenet \
		--enable-uaescsi \
		--enable-uaeserial \
		--disable-udis86 \
		--enable-vpar \
		--enable-xml-shader \
		--enable-zip \
		--without-cef \
		--with-glad \
		--without-qt \
		$(use_enable jit) \
		$(use_enable jit jit-fpu) \
		$(use_with fmv libmpeg2) \
		$(use_with glew)
}

src_install() {
	default

	# Needed for QEMU-UAE.
	insinto /usr/include/uae
	doins src/include/uae/{api,attributes,log,ppc,qemu,types}.h
}

pkg_postinst() {
	xdg_pkg_postinst
	elog "Install app-emulation/fs-uae-launcher for a better graphical interface."
}
