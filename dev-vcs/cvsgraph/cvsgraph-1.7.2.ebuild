# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="CVS/RCS repository grapher"
HOMEPAGE="
	https://www.vagrearg.org/content/cvsgraph
	https://gitlab.com/bertho/cvsgraph/
"
SRC_URI="https://www.vagrearg.org/cvsgraph/release/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="gif jpeg nls png truetype zlib"

DEPEND="
	media-libs/gd
	gif? ( media-libs/giflib )
	jpeg? ( media-libs/libjpeg-turbo:= )
	png? ( media-libs/libpng )
	truetype? ( media-libs/freetype )
	zlib? ( sys-libs/zlib )
"
RDEPEND="
	${DEPEND}
	virtual/pkgconfig
"

src_configure() {
	local myeconfargs=(
		$(use_enable gif)
		$(use_enable jpeg)
		$(use_enable nls)
		$(use_enable png)
		$(use_enable truetype)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	dobin cvsgraph
	insinto /etc
	doins cvsgraph.conf
	doman cvsgraph.1 cvsgraph.conf.5
	dodoc ChangeLog README AUTHORS contrib/*.php
	dodoc -r contrib/automatic_documentation
}
