# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Simulate keyboard input and mouse activity, move and resize windows"
HOMEPAGE="https://www.semicomplete.com/projects/xdotool/"
SRC_URI="https://github.com/jordansissel/xdotool/releases/download/v${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="examples"

# Many the tests want to manually start Xvfb regardless of whether there
# is an X server running or not (i.e. does not play nicely with virtualx),
# some tests require x11-wm/openbox, some try to run a complete Gnome
# session. All of them require a Ruby interpreter with dev-ruby/minitest
# installed. In short, supporting tests here will need MUCH work.
RESTRICT="test"

RDEPEND="x11-libs/libX11
	x11-libs/libXi
	x11-libs/libXinerama
	x11-libs/libXtst
	x11-libs/libxkbcommon"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig
	x11-base/xorg-proto"

PATCHES=(
	"${FILESDIR}"/${PN}-3.20210804.2-no_hardcoded_pkg-config.patch
	"${FILESDIR}"/${PN}-3.20210804.2-no_ldconfig.patch
)

DOCS=( CHANGELIST README.md )

src_compile() {
	tc-export CC LD PKG_CONFIG
	emake PREFIX="${EPREFIX}/usr"
}

src_install() {
	emake PREFIX="${ED}/usr" INSTALLMAN="${ED}/usr/share/man" INSTALLLIB="${ED}/usr/$(get_libdir)" install

	use examples && DOCS+=( examples )
	einstalldocs
}
