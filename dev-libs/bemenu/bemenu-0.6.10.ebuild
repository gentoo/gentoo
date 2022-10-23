# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="dmenu clone for wayland"
HOMEPAGE="https://github.com/Cloudef/bemenu"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Cloudef/bemenu.git"
else
	SRC_URI="https://github.com/Cloudef/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm64 x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="doc ncurses wayland X"

# Require at least one backend be built
REQUIRED_USE="|| ( ncurses wayland X )"

DEPEND="
	ncurses? ( sys-libs/ncurses:= )
	wayland? (
		dev-libs/wayland
		dev-libs/wayland-protocols
		x11-libs/cairo
		x11-libs/pango
		x11-libs/libxcb
	)
	X? (
		x11-libs/libxcb
		x11-libs/libXext
		x11-libs/libX11
		x11-libs/cairo[X]
		x11-libs/pango[X]
		x11-libs/libXinerama
	)
"
RDEPEND="${DEPEND}"
BDEPEND="doc? ( app-doc/doxygen )"

src_compile() {
	tc-export CC

	emake clients $(usex ncurses curses "") $(usex X x11 "") $(usex wayland wayland "") PREFIX=/usr libdir=/$(get_libdir)
	use doc && emake doxygen PREFIX=/usr libdir=/$(get_libdir)
}

src_install() {
	emake install PREFIX="${D}"/usr libdir=/$(get_libdir)
}
