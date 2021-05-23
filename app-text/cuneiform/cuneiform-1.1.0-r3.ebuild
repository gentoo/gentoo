# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake flag-o-matic

PV_MAJ=$(ver_cut 1-2)
MY_P=${PN}-linux-${PV}

DESCRIPTION="An enterprise quality OCR engine by Cognitive Technologies"
HOMEPAGE="https://launchpad.net/cuneiform-linux"
SRC_URI="https://launchpad.net/${PN}-linux/${PV_MAJ}/${PV_MAJ}/+download/${MY_P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug graphicsmagick"

RDEPEND="
	!graphicsmagick? ( media-gfx/imagemagick:= )
	graphicsmagick? ( media-gfx/graphicsmagick:= )"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

PATCHES=(
	# From Fedora
	"${FILESDIR}"/${P}-c-assert.patch
	"${FILESDIR}"/${P}-libm.patch
	"${FILESDIR}"/${P}-fix_buffer_overflow.patch
	"${FILESDIR}"/${P}-fix_buffer_overflow_2.patch
	"${FILESDIR}"/${P}-gcc6.patch
	"${FILESDIR}"/${P}-gcc7.patch
	"${FILESDIR}"/${P}-typos.patch
	"${FILESDIR}"/${P}-gcc11.patch
)

src_prepare() {
	use graphicsmagick && PATCHES+=( "${FILESDIR}"/${P}-graphicsmagick.patch )
	cmake_src_prepare

	# respect LDFLAGS
	sed -i 's:\(set[(]CMAKE_SHARED_LINKER_FLAGS "[^"]*\):\1 $ENV{LDFLAGS}:' \
		cuneiform_src/CMakeLists.txt || die "failed to sed for LDFLAGS"

	# Fix automagic dependencies / linking
	if use graphicsmagick; then
		sed -i "s:find_package(ImageMagick COMPONENTS Magick++):#DONOTFIND:" \
			cuneiform_src/CMakeLists.txt || die
	fi
}

src_configure() {
	append-flags -fcommon
	cmake_src_configure
}

src_install() {
	cmake_src_install
	doman "${FILESDIR}"/${PN}.1
}
