# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOCS_BUILDER="doxygen"
inherit docs toolchain-funcs

DESCRIPTION="Simulate keyboard input and mouse activity, move and resize windows"
HOMEPAGE="https://www.semicomplete.com/projects/xdotool/"
SRC_URI="https://github.com/jordansissel/xdotool/releases/download/v${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ppc ppc64 ~riscv sparc x86"
IUSE="examples"

# tests have various troublesome requirements
RESTRICT="test"

# libXi is "unused" but it still uses headers from it and relies on the
# compiler optimizing out a function to be dropped by as-needed, so keep
# until next release (not important to patch given libXtst pulls libXi
# anyway, so the dependency is not really avoidable either way)
# https://github.com/jordansissel/xdotool/pull/446
RDEPEND="
	x11-libs/libX11
	x11-libs/libXi
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

PATCHES=(
	"${FILESDIR}"/${PN}-3.20210804.2-no_hardcoded_pkg-config.patch
)

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
