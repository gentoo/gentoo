# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8,9} )

inherit autotools python-single-r1

DESCRIPTION="Roleplaying game engine"
HOMEPAGE="http://adonthell.nongnu.org/"
SRC_URI="https://savannah.nongnu.org/download/${PN}/${PN}-src-${PV}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc nls"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	media-libs/freetype
	media-libs/libogg
	media-libs/libsdl2[X,video,sound]
	media-libs/libvorbis
	media-libs/sdl2-mixer[vorbis]
	media-libs/sdl2-ttf
	sys-libs/zlib
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	dev-lang/swig"
BDEPEND="
	virtual/pkgconfig
	doc? (
		app-doc/doxygen
		media-gfx/graphviz
	)
	nls? ( sys-devel/gettext )"

DOCS=( AUTHORS NEWBIE NEWS README )

PATCHES=(
	"${FILESDIR}/${P}-ar.patch"
)

src_prepare() {
	default
	eautoreconf
}

pkg_setup() {
	python-single-r1_pkg_setup
}

src_configure() {
	econf \
		--program-transform-name="s:${PN}-$(ver_cut 1-2):${PN}:" \
		--disable-py-debug \
		--with-python=${EPYTHON} \
		$(use_enable nls) \
		$(use_enable doc)
}
