# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit libtool

DESCRIPTION="versatile and fast Unicode/ASCII/ANSI graphics renderer"
HOMEPAGE="https://hpjansson.org/chafa/ https://github.com/hpjansson/chafa"
SRC_URI="https://hpjansson.org/chafa/releases/${P}.tar.xz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~loong ~mips ~ppc ppc64 ~riscv ~sparc x86"
IUSE="avif heif jpegxl svg +tools webp"

RDEPEND="
	dev-libs/glib:2
	tools? (
		media-libs/freetype:2
		media-libs/libjpeg-turbo:=
		media-libs/tiff:=
		avif? ( media-libs/libavif:= )
		heif? ( media-libs/libheif:= )
		jpegxl? ( media-libs/libjxl:= )
		svg? (
			gnome-base/librsvg:2
			x11-libs/cairo
		)
		webp? ( media-libs/libwebp:= )
	)
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

QA_CONFIG_IMPL_DECL_SKIP=(
	# checking for intrinsics, will fail where not supported. bug #927102
	_mm_popcnt_u64
)

src_prepare() {
	default
	elibtoolize
}

src_configure() {
	if ! use tools; then
		use avif && ewarn "USE=avif is ignored if USE=tools is not set"
		use heif && ewarn "USE=heif is ignored if USE=tools is not set"
		use jpegxl && ewarn "USE=jpegxl is ignored if USE=tools is not set"
		use svg && ewarn "USE=svg is ignored if USE=tools is not set"
		use webp && ewarn "USE=webp is ignored if USE=tools is not set"
	fi

	local myconf=(
		--disable-man
		$(use_with tools)
		$(use_with avif)
		$(use_with heif)
		$(use_with jpegxl jxl)
		$(use_with svg)
		$(use_with tools jpeg)
		$(use_with tools tiff)
		$(use_with webp)
	)

	econf "${myconf[@]}"
}

src_install() {
	default

	use tools && doman docs/chafa.1

	find "${ED}" -name '*.la' -delete || die
}
