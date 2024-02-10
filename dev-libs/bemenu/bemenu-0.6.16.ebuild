# Copyright 2019-2024 Gentoo Authors
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
	KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="doc ncurses wayland X"

# Require at least one backend be built
REQUIRED_USE="|| ( ncurses wayland X )"

RDEPEND="
	ncurses? ( sys-libs/ncurses:= )
	wayland? (
		dev-libs/wayland
		x11-libs/cairo
		x11-libs/libxkbcommon
		x11-libs/pango
	)
	X? (
		x11-libs/cairo[X]
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXinerama
		x11-libs/libxcb:=
		x11-libs/pango[X]
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-text/scdoc
	virtual/pkgconfig
	doc? ( app-text/doxygen )
	wayland? (
		dev-libs/wayland-protocols
		dev-util/wayland-scanner
	)
"

src_compile() {
	tc-export CC

	emake clients $(usev ncurses curses) $(usev X x11) $(usev wayland) PREFIX="${EPREFIX}"/usr libdir=/$(get_libdir)
	use doc && emake doxygen PREFIX="${EPREFIX}"/usr libdir=/$(get_libdir)
}

src_install() {
	emake install DESTDIR="${D}" PREFIX="${EPREFIX}"/usr libdir=/$(get_libdir)
}
