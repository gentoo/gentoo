# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="versatile and fast Unicode/ASCII/ANSI graphics renderer"
HOMEPAGE="https://hpjansson.org/chafa/ https://github.com/hpjansson/chafa"
SRC_URI="https://hpjansson.org/chafa/releases/${P}.tar.xz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs +tools"

RDEPEND="
	dev-libs/glib:2
	media-gfx/imagemagick:0=
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	local econfargs=(
		$(use_enable static-libs static)
		# install manpage manually
		--disable-man
		$(use_with tools)
	)

	econf "${econfargs[@]}"
}

src_install() {
	local DOCS=( AUTHORS NEWS README TODO )
	default

	use tools && doman docs/chafa.1

	find "${ED}"/usr/lib* -name '*.la' -delete || die
}
