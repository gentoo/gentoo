# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo shell-completion toolchain-funcs

DESCRIPTION="Color picker and magnifier for X11"
HOMEPAGE="https://codeberg.org/NRK/sxcs"

SRC_URI="https://codeberg.org/NRK/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXcursor
"
DEPEND="${RDEPEND}"

src_compile() {
	edo $(tc-getCC) -o sxcs sxcs.c ${CFLAGS} ${LDFLAGS} -l X11 -l Xcursor
}

src_install() {
	dobin sxcs
	doman sxcs.1
	dodoc README.md
	dozshcomp etc/zsh-completion/_sxcs
}
