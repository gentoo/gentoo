# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

SSHASH="cbc89a71a61fd2d164c3fdc3ef4d3fa809c1741a"
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

src_install() {
	default
	doman ${PN}.1
}
