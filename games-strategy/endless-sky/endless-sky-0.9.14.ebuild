# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9,10} )
inherit python-any-r1 scons-utils toolchain-funcs xdg

DESCRIPTION="Space exploration, trading & combat in the tradition of Terminal Velocity"
HOMEPAGE="https://endless-sky.github.io"
SRC_URI="https://github.com/endless-sky/endless-sky/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="CC-BY-SA-4.0 CC-BY-SA-3.0 GPL-3+ public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

# Needs work; doesn't link against SDL 2
RESTRICT="test"

RDEPEND="media-libs/glew:0=
	media-libs/libsdl2
	media-libs/libjpeg-turbo:=
	media-libs/libmad
	media-libs/libpng:=
	media-libs/openal
	virtual/opengl"
DEPEND="${RDEPEND}
	test? ( dev-cpp/catch:0 )"

PATCHES=(
	"${FILESDIR}"/${PN}-0.9.14-respect-cflags.patch
	"${FILESDIR}"/${PN}-0.9.14-no-games-path.patch
	"${FILESDIR}"/${PN}-0.9.14-dont-compress-man-page.patch
	"${FILESDIR}"/${PN}-0.9.14-use-system-catch2.patch
)

src_compile() {
	tc-export AR CXX

	escons
}

src_test() {
	escons test
}

src_install() {
	escons PREFIX="${ED}"/usr/ install
}

pkg_postinst() {
	xdg_pkg_postinst

	einfo "Endless Sky provides high-res sprites for high-dpi screens."
	einfo "If you want to use them, download"
	einfo
	einfo "   https://github.com/endless-sky/endless-sky-high-dpi/releases"
	einfo
	einfo "and extract it to ~/.local/share/endless-sky/plugins/."
	einfo
	einfo "Enjoy."
}
