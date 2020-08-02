# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit autotools eutils python-single-r1

DESCRIPTION="roleplaying game engine"
HOMEPAGE="http://adonthell.nongnu.org/"
SRC_URI="https://savannah.nongnu.org/download/${PN}/${PN}-src-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc nls"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	media-libs/freetype
	media-libs/libogg
	media-libs/libsdl:0[X,video,sound]
	media-libs/libvorbis
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-ttf
	sys-libs/zlib
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	dev-lang/swig
	virtual/pkgconfig
	doc? (
		app-doc/doxygen
		media-gfx/graphviz
	)
	nls? ( sys-devel/gettext )"

S=${WORKDIR}/${PN}-${PV/a/}

PATCHES=(
		"${FILESDIR}"/${P}-configure.in.patch
		"${FILESDIR}"/${P}-format.patch
		"${FILESDIR}"/${P}-gcc46.patch
		"${FILESDIR}"/${P}-glibc-2.10.patch
		"${FILESDIR}"/${P}-freetype_pkgconfig.patch
)

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	default

	sed -i \
		-e "/AC_PATH_PROGS/s:python:${EPYTHON}:" \
		configure.in || die "sed failed"
	rm -f ac{local,include}.m4
	eautoreconf
}

src_configure() {
	econf \
		--disable-py-debug \
		$(use_enable nls) \
		$(use_enable doc)
}

src_install() {
	emake DESTDIR="${D}" install
	keepdir /usr/share/${PN}/games
	dodoc AUTHORS ChangeLog FULLSCREEN.howto NEWBIE NEWS README
}
