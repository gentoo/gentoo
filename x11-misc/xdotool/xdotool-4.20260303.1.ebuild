# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOCS_BUILDER="doxygen"
inherit docs toolchain-funcs

DESCRIPTION="Simulate keyboard input and mouse activity, move and resize windows"
HOMEPAGE="https://www.semicomplete.com/projects/xdotool/"
# TODO: try old SRC_URI next bump in case the missing assets was not permanent,
# albeit the GH archive is usable as-is given nothing is generated
#SRC_URI="https://github.com/jordansissel/xdotool/releases/download/v${PV}/${P}.tar.gz"
SRC_URI="
	https://github.com/jordansissel/xdotool/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="BSD"
SLOT="0/4"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="examples"

# tests have various troublesome requirements
RESTRICT="test"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXinerama
	x11-libs/libXtst
	x11-libs/libxkbcommon
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	virtual/pkgconfig
"

src_prepare() {
	default

	sed -i 's/pkg-config/$(PKG_CONFIG)/' Makefile || die
}

src_compile() {
	tc-export CC LD PKG_CONFIG

	emake PREFIX="${EPREFIX}"/usr
	docs_compile
}

src_install() {
	emake PREFIX="${ED}"/usr INSTALLMAN="${ED}"/usr/share/man \
		INSTALLLIB="${ED}"/usr/$(get_libdir) LDCONFIG=: install

	dodoc -r CHANGELIST $(usev examples)
	einstalldocs
}
