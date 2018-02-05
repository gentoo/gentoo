# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{5,6} )

inherit python-single-r1 toolchain-funcs

DESCRIPTION="a cross-platform, fast, featureful, GPU-based terminal emulator"
HOMEPAGE="https://github.com/kovidgoyal/kitty"
SRC_URI="https://github.com/kovidgoyal/kitty/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug imagemagick wayland"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

COMMON_DEPS="
	${PYTHON_DEPS}
	>=media-libs/harfbuzz-1.5.0:=
	sys-libs/zlib
	media-libs/libpng:0=
	media-libs/freetype:2
	media-libs/fontconfig
	x11-libs/libXcursor
	x11-libs/libXrandr
	x11-libs/libXinerama
	x11-libs/libxkbcommon
	wayland? (
		dev-libs/wayland
		>=dev-libs/wayland-protocols-1.12
	)
"
RDEPEND="
	${COMMON_DEPS}
	imagemagick? ( virtual/imagemagick-tools )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${P}-flags.patch
	"${FILESDIR}"/${P}-svg-icon.patch)

src_prepare() {
	default

	# respect libdir
	sed -i "/libdir =/s/'lib'/'$(get_libdir)'/" setup.py || die

	# disable wayland as required
	if ! use wayland; then
		sed -i "/'x11 wayland'/s/ wayland//" setup.py || die
	fi

	tc-export CC
}

doecho() {
	echo "$@"
	"$@" || die
}

src_compile() {
	doecho "${EPYTHON}" setup.py --verbose $(usex debug --debug "") linux-package
}

src_test() {
	"${EPYTHON}" test.py || die
}

src_install() {
	mkdir -p "${ED}"usr || die
	cp -r linux-package/* "${ED}usr" || die

	dodoc CHANGELOG.rst *.asciidoc
}
