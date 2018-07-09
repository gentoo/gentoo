# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic

DESCRIPTION="A software version control visualization tool"
HOMEPAGE="http://gource.io/"
SRC_URI="https://github.com/acaudwell/Gource/releases/download/${P}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEPEND="
	>=dev-libs/boost-1.46:=[threads(+)]
	>=media-libs/glew-1.5:0=
	>=media-libs/libpng-1.2:0=
	media-libs/libsdl2[video,opengl,X]
	media-libs/sdl2-image[jpeg,png]
	dev-libs/libpcre:3
	dev-libs/tinyxml
	media-libs/freetype:2
	media-libs/mesa
	virtual/glu:0
"
RDEPEND="${COMMON_DEPEND}
	media-fonts/freefont
"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	>=media-libs/glm-0.9.3
"

DOCS=( README ChangeLog THANKS )

src_configure() {
	# fix bug #386525
	# this enables gource to be compiled against dev-libs/tinyxml[stl]
	if has_version dev-libs/tinyxml[stl]; then
		append-cppflags -DTIXML_USE_STL;
	fi

	econf \
		--enable-ttf-font-dir=/usr/share/fonts/freefont/ \
		--with-tinyxml
}
