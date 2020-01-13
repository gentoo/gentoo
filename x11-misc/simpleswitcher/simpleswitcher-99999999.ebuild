# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit git-r3 toolchain-funcs

DESCRIPTION="lightweight EWMH window switcher with features and looks of dmenu"
HOMEPAGE="https://github.com/seanpringle/simpleswitcher"
EGIT_REPO_URI="https://github.com/seanpringle/simpleswitcher"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""

RDEPEND="
	x11-libs/libX11
	x11-libs/libXft
	x11-libs/libXinerama
	x11-libs/libXres
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

src_compile() {
	tc-export CC
	default
}

src_install() {
	default
	doman ${PN}.1
}
