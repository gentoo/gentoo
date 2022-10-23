# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="A software version control visualization tool"
HOMEPAGE="https://gource.io/"
SRC_URI="https://github.com/acaudwell/Gource/releases/download/${P}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

COMMON_DEPEND="
	dev-libs/boost:=
	>=media-libs/glew-1.5:0=
	>=media-libs/libpng-1.2:0=
	media-libs/libsdl2[video,opengl,X]
	media-libs/sdl2-image[jpeg,png]
	dev-libs/libpcre2:=
	dev-libs/tinyxml
	media-libs/libglvnd[X]
	media-libs/freetype:2
	virtual/glu:0
"
RDEPEND="${COMMON_DEPEND}
	media-fonts/freefont
"
DEPEND="${COMMON_DEPEND}
	>=media-libs/glm-0.9.3
"
BDEPEND="virtual/pkgconfig"

DOCS=( README.md ChangeLog THANKS )

src_prepare() {
	default

	sed -e "/data\/gource.1/s/^/#/" -i Makefile.am || die
	eautoreconf
}

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

src_install() {
	default
	doman data/gource.1
}
