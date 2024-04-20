# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit savedconfig toolchain-funcs

DESCRIPTION="Simple generic tabbed fronted to xembed aware applications"
HOMEPAGE="https://tools.suckless.org/tabbed/"
SRC_URI="https://dl.suckless.org/tools/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXft
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
	restore_config config.h
}

src_compile() {
	tc-export CC PKG_CONFIG

	local emakeargs=(
		TABBED_CFLAGS="${CFLAGS} $("${PKG_CONFIG}" --cflags x11 xft)"
		TABBED_LDFLAGS="${LDFLAGS} $("${PKG_CONFIG}" --libs x11 xft)"
	)

	emake "${emakeargs[@]}"
}

src_install() {
	local emakeargs=(
		DESTDIR="${D}"
		PREFIX="${EPREFIX}/usr"
		DOCPREFIX="${EPREFIX}/usr/share/doc/${PF}"
	)
	emake "${emakeargs[@]}" install

	save_config config.h
}
