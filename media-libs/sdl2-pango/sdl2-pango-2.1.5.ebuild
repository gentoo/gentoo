# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="SDL2 port of SDL_Pango for rendering text using Pango"
HOMEPAGE="https://github.com/markuskimius/SDL2_Pango/"
SRC_URI="https://github.com/markuskimius/SDL2_Pango/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="dev-libs/glib:2
	media-libs/freetype
	media-libs/fontconfig
	media-libs/harfbuzz:=
	media-libs/libsdl2[video]
	x11-libs/pango"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/SDL2_Pango-${PV}"

src_install() {
	default
	find "${ED}" \( -name "*.a" -o -name "*.la" \) -delete \
		|| die "Failed to delete .a or .la files"
}
