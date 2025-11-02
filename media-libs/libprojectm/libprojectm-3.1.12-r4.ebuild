# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="${PV/_/-}"
inherit autotools xdg

DESCRIPTION="Graphical music visualization plugin similar to milkdrop"
HOMEPAGE="https://github.com/projectM-visualizer/projectm"
SRC_URI="https://github.com/projectM-visualizer/projectm/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/projectm-${MY_PV}/"

LICENSE="LGPL-2"
SLOT="0/2"
KEYWORDS="amd64 arm arm64 ~loong ppc ppc64 ~riscv ~sparc x86"
IUSE="gles2 sdl"

RDEPEND="
	media-libs/glm
	media-libs/libglvnd[X(+)]
	sys-libs/zlib
	sdl? ( >=media-libs/libsdl2-2.0.5 )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-build/autoconf-archive
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/${P}-missing-gl-header.patch" # bug 792204
	"${FILESDIR}/${P}-cxx14.patch"
	"${FILESDIR}/${PN}-3.1.12-drop-automagic-libcxx.patch"
)

src_prepare() {
	default
	# bug 940300
	cp "${BROOT}"/usr/share/aclocal/ax_have_qt.m4 m4/autoconf-archive/ax_have_qt.m4 || die
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable gles2 gles)
		--disable-jack # bug #961970
		--disable-pulseaudio # bug #961970
		--disable-qt # bug #961970
		$(use_enable sdl)
		--enable-emscripten=no
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
	find "${ED}" -name '*.a' -delete || die
}
