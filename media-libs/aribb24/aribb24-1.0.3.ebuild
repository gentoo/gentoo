# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Library for decoding ARIB STD-B24 subtitles"
HOMEPAGE="https://github.com/nkoriyama/aribb24"
SRC_URI="https://github.com/nkoriyama/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc ppc64 x86"

RDEPEND="media-libs/libpng:0="
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf --disable-static
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
