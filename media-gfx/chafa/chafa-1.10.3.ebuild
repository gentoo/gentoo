# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="versatile and fast Unicode/ASCII/ANSI graphics renderer"
HOMEPAGE="https://hpjansson.org/chafa/ https://github.com/hpjansson/chafa"
SRC_URI="https://hpjansson.org/chafa/releases/${P}.tar.xz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="amd64 arm64 ~riscv x86"
IUSE="+tools"

RDEPEND="
	dev-libs/glib:2
	media-gfx/imagemagick:0=
	tools? ( >=media-libs/freetype-2.0.0 )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	econf \
		--disable-man \
		$(use_with tools)
}

src_install() {
	local DOCS=( AUTHORS NEWS README TODO )
	default

	use tools && doman docs/chafa.1

	find "${ED}" -name '*.la' -delete || die
}
