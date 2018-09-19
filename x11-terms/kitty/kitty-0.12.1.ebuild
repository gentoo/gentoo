# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{6,7} )

inherit python-single-r1 toolchain-funcs gnome2-utils

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/kovidgoyal/kitty.git"
	inherit git-r3
else
	SRC_URI="https://github.com/kovidgoyal/kitty/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A modern, hackable, featureful, OpenGL-based terminal emulator"
HOMEPAGE="https://github.com/kovidgoyal/kitty"

LICENSE="GPL-3"
SLOT="0"
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
	x11-libs/libXi
	x11-libs/libXinerama
	x11-libs/libxkbcommon[X]
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
	>=dev-python/sphinx-1.7[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.11.0-flags.patch
	"${FILESDIR}"/${PN}-0.11.0-svg-icon.patch
)

src_prepare() {
	default

	# disable wayland as required
	if ! use wayland; then
		sed -i "/'x11 wayland'/s/ wayland//" setup.py || die
	fi

	# respect doc dir
	sed -i "/htmldir =/s/appname/'${PF}'/" setup.py

	tc-export CC
}

doecho() {
	echo "$@"
	"$@" || die
}

src_compile() {
	doecho "${EPYTHON}" setup.py --verbose $(usex debug --debug "") --libdir-name $(get_libdir) linux-package
}

src_test() {
	export KITTY_CONFIG_DIRECTORY=${T}
	"${EPYTHON}" test.py || die
}

src_install() {
	mkdir -p "${ED}"usr || die
	cp -r linux-package/* "${ED}usr" || die
	python_fix_shebang "${ED}"
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
