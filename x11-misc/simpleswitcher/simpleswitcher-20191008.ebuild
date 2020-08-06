# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

SSHASH="7230421aa2e3364e3b4620f1ea3760f8f810b1a5"
DESCRIPTION="lightweight EWMH window switcher with features and looks of dmenu"
HOMEPAGE="https://github.com/seanpringle/simpleswitcher"
SRC_URI="https://github.com/seanpringle/simpleswitcher/archive/${SSHASH}.tar.gz -> ${P}-${SSHASH}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

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
S=${WORKDIR}/${PN}-${SSHASH}

src_compile() {
	tc-export CC
	default
}
