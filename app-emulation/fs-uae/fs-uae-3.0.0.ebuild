# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools xdg-utils

DESCRIPTION="Integrates the most accurate Amiga emulation code available from WinUAE"
HOMEPAGE="https://fs-uae.net/"
SRC_URI="https://fs-uae.net/stable/${PV}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="fmv glew"

RDEPEND="
	dev-libs/glib:2
	media-libs/libpng:0=
	media-libs/libsdl2[opengl,X]
	media-libs/openal
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
		--enable-jit \
		--enable-jit-fpu \
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
		--with-glad \
		--without-qt \
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
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	xdg_icon_cache_update

	elog "Install app-emulation/fs-uae-launcher for a better graphical interface."
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
}
